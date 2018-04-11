require_relative "../test_helper"

class Signup < FeatureTest
  let(:form){ custom_forms(:group_signup) }
  before { visit "/groups/#{form.group.id}/signup_forms/#{form.id}/signups/new" }

  describe "viewing signup form" do
    it "has a title" do
      page.must_have_content form.title
    end

    it "has a description" do
      page.html.must_match form.description
    end

    it "has a call to action" do
      page.must_have_text form.call_to_action.titleize
    end

    it "has a submit button" do
      page.must_have_selector "input.submit"
    end

    it "has inputs for creating a member" do
      CustomForm::INPUT_GROUPS.each do |input_group|
        form.send(input_group).inputs.each do |input|
          ig = form.send(input_group)
          page
            .find(input_selector_for(ig, input))['placeholder']
            .must_equal(ig.label_for(input))
        end
      end
    end
  end

  describe "submitting signup form" do
    let(:input_groups){ CustomForm::INPUT_GROUPS.map{ |ig| form.send(ig) } }
    let(:person_count){ Person.count }
    let(:membership_count){ Membership.count }
    let(:new_member){ Person.last }

    before do
      # because minitest won't allow `let!`
      person_count
      membership_count
    end

    describe "with no errors" do
      before do
        fill_out_form values_by_input(input_groups)
        click_button form.submit_text
      end

      it "creates a new person" do
        Person.count.must_equal person_count + 1
      end

      it "creates a new membership" do
        Membership.count.must_equal membership_count + 1
      end

      it "stores persons's contact info" do
        [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
          new_member.reload.send(msg).first.primary?.must_equal true
        end
      end
    end

    describe "with errors" do
      before do
        fill_out_form(
          person_email_addresses_attributes_0_address: 'invalid',
          person_phone_numbers_attributes_0_number: 'invalid',
          person_personal_addresses_attributes_0_region: 'invalid',
          person_personal_addresses_attributes_0_postal_code: 'invalid'
        )
        click_button form.submit_text
      end

      # TODO (aguestuser|07-Feb-2018)
      # these error messages are T.R.A.S.H.

      it "allows blank fields" do
        page.wont_have_content "First name can't be blank"
      end

      it "shows an error for invalid email address" do
        page.must_have_content(
          "Email address 'invalid' is not a valid email address"
        )
      end

      it "shows an error for invalid phone number" do
        page.must_have_content(
          "Phone number invalid is not a valid phone number"
        )
      end

      it "shows an error for invalid postal code" do
        page.must_have_content(
          "Zip code invalid is not a valid postal code"
        )
      end

      it "shows an error for invalid state" do
        page.must_have_content("State invalid must be one of:")
      end
    end

    describe "with google group integration enabled" do
      let(:fancy_group){ groups(:ohio_chapter) }
      let(:google_group_email){ 'ohio-chapter@nationalnetwork.com' }
      let(:google_group_group_key){ "#{google_group_email}.test-google-a.com" }
      let(:authentication_double){ double(Google::Auth::ServiceAccountCredentials) }
      let(:directory_service_double){ double(Google::Apis::AdminDirectoryV1::DirectoryService)}
      let(:google_group_double) do
        double(Google::Apis::AdminDirectoryV1::Group,
               id: 1,
               email: google_group_email,
               non_editable_aliases: [google_group_group_key]
              )
      end
      let(:google_group_member_double){ double(Google::Apis::AdminDirectoryV1::Member)}

      before do
        # authentication
        allow(Google::Auth::ServiceAccountCredentials)
          .to receive(:make_creds).and_return(authentication_double)
        allow(authentication_double)
          .to receive(:sub=)
        allow(Google::Auth::ServiceAccountCredentials)
          .to receive(:sub=)

        # connecting to directory service
        allow(Google::Apis::AdminDirectoryV1::DirectoryService)
          .to receive(:new).and_return(directory_service_double)
        allow(directory_service_double)
          .to receive(:authorization=)

        # fetching group
        allow(directory_service_double)
          .to receive(:get_group).and_return(google_group_double)

        # adding member
        allow(Google::Apis::AdminDirectoryV1::Member)
          .to receive(:new).and_return(google_group_member_double)
        allow(directory_service_double).to receive(:insert_member)

        # fill out form!
        form = SignupForm.for(fancy_group)
        visit "/groups/#{fancy_group.id}/signup_forms/#{form.id}/signups/new"
        fill_out_form(
          'First Name*'    => 'Serious',
          'Last Name*'     => 'Person',
          'Email Address*' => 'serious@person.com',
          'Zip Code*'      => '11111',
          'Phone Number'   => '111-111-1111'
        )
        click_button form.submit_text
      end

      it "adds member to group's google group" do
        expect(Google::Apis::AdminDirectoryV1::Member)
          .to have_received(:new).with(email: Person.last.email,
                                       role: GoogleAPI::Roles::MEMBER)

        expect(directory_service_double)
          .to have_received(:insert_member).with(google_group_double.id,
                                                 google_group_member_double)
      end
    end

    describe "in a form that lacks any address input" do
      it "should not throw an error on submit"
      # NOTE: (aguestuser|08 Feb 2018)
      # left pending to denote bug fixed in 075c8c2a
    end
  end

  private

  def count_contact_infos
    EmailAddress.count + PersonalAddress.count + PhoneNumber.count
  end
  def input_selector_for(input_group, input)
    case input_group
    when PersonInputGroup
      "#person_#{input}"
    else
      "#person_#{input_group.resource}_attributes_0_#{input}"
    end
  end

  def values_by_input(input_groups)
    input_groups.reduce({}) do |acc, input_group|
      input_group.inputs.reduce(acc) do |_acc, input|
        _acc.merge(
          input_selector_for(input_group, input).gsub("#", "") =>
          value_for(input_group, input)
        )
      end
    end
  end

  def value_for(input_group, input)
    case input_group
    when PersonInputGroup
      people(:new_signup).send(input)
    else
      attr = people(:new_signup).send(input_group.resource).first.send(input)
      attr = attr.respond_to?(:join) ? attr.join(", ") : attr
      is_email_address?(input_group, input)? "fake@example.com" : attr
    end
  end

  def is_email_address?(input_group, input)
    input_group.is_a?(EmailInputGroup) && input == 'address'
  end
end
