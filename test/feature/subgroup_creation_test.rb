require_relative "../test_helper"
require 'minitest/mock'

class SubgroupCreation < FeatureTest

  let(:group){ groups(:one) }
  RESOURCES = %w[group address person membership phone_number email_address signup_form].freeze

  before { visit "/groups/#{group.id}/subgroups/new" }

  describe "viewing group creation form" do
    it "has parent group's name in title" do
      page.must_have_content group.name
    end

    it "has fields for creating a group" do
      ['Name', 'Zipcode (group)'].each do |label|
        page.find("input[placeholder='#{label}']").wont_be_nil
      end
    end

    it "has a large description text area for group" do
      page.find(
        "textarea[placeholder='Description (may contain HTML)']"
      ).wont_be_nil
    end

    it "has correct required group fields" do
      page.find("input[placeholder='Name'][required='required']").wont_be_nil
    end

    it "has groups for creating an organizer" do
      [
        'First name',
        'Last name',
        'Password',
        'Email',
        'Phone number',
        'Zipcode (personal)',
      ].each do |label|
        page.find("input[placeholder='#{label}']").wont_be_nil
      end
    end

    it "has correct required organizer fields" do
      ['Email', 'Password', 'First Name', 'Last Name'].each do |label|
        "input[placeholder='#{label}'][required='required']"
      end
    end
  end

  describe "submitting form" do
    let(:group_count){ Group.count }
    let(:address_count){ Address.count }
    let(:person_count){ Person.count }
    let(:phone_number_count){ PhoneNumber.count }
    let(:email_address_count){ EmailAddress.count }
    let(:membership_count){ Membership.count }
    let(:signup_form_count){ SignupForm.count }
    let(:last_person){ Person.last }
    let(:deliveries_count){ ActionMailer::Base.deliveries.size }

    describe "with no errors" do
      before do
        RESOURCES.each { |r| send("#{r}_count") }
        deliveries_count
        perform_enqueued_jobs do
          fill_out_form(
            'Name' => 'Jawbreaker',
            'Description (may contain HTML)' => 'I want to be a boat, I want to learn to swim',
            'Zipcode (group)' => '90210',
            'First name' => 'herbert',
            'Last name' => 'stencil',
            'Password' => 'password',
            'Phone number' => '212-867-5309',
            'Email' => 'foo@bar.com',
            'Zipcode (personal)' => '90211'
          )
          click_button "Submit"
        end
      end

      RESOURCES.each do |resource|
        it "creates new #{resource}(s)" do
          if resource === "address"
            Address.count.must_equal(address_count + 2)
          else
            resource.camelize.constantize.count.must_equal(
              send("#{resource}_count") + 1
            )
          end
        end
      end

      it "redirects to the user's profile page" do
        page.current_path.must_equal "/profile"
        page.must_have_content "Welcome"
      end

      it "saves group info" do
        Group.last.attributes.slice(*%w[name description]).must_equal(
          'name' =>  "Jawbreaker",
          'description' => 'I want to be a boat, I want to learn to swim'
        )
      end

      it "saves group location"  do
        Group.last.location.postal_code.must_equal "90210"
      end

      it "saves organizer info" do
        Person.last.attributes.slice(*%w[given_name family_name]).must_equal(
          'given_name' => 'herbert',
          'family_name' => 'stencil'
        )
      end

      it "saves organizer password" do
        last_person.encrypted_password.wont_be_nil
        last_person.valid_password?("password")
      end

      it "saves organizer contact info" do
        last_person.email_addresses.last.address.must_equal 'foo@bar.com'
        last_person.phone_numbers.last.number.must_equal '212-867-5309'
        last_person.personal_addresses.last.postal_code.must_equal '90211'
      end

      it "saves contact infos as 'primary'" do
        last_person.primary_email_address.must_equal 'foo@bar.com'
        last_person.primary_phone_number.must_equal '212-867-5309'
        last_person.primary_personal_address.postal_code.must_equal '90211'
      end

      it "sends a welcome email (asynchronously)" do
        ActionMailer::Base
          .deliveries.size.must_equal(deliveries_count + 1)
      end
    end

    describe "with errors" do
      before do
        RESOURCES.each { |r| send("#{r}_count") }
        fill_out_form({})
        click_button "Submit"
      end

      it "does not create any resources" do
        RESOURCES.each do |resource|
          resource.camelize.constantize.count.must_equal(send("#{resource}_count"))
        end
      end

      it "displays errors" do
        page.must_have_content "error"
      end
    end

    describe "with google group integration enabled" do
      let(:fancy_group){ groups(:ohio_chapter) }
      let(:google_group_email){ 'ohio-chapter@nationalnetwork.com' }
      let(:google_group_group_key){ "#{google_group_email}.test-google-a.com" }
      let(:google_group_url){ "https://groups.google.com/a/nationalnetwork.com/forum/#!forum/ohio-chapter" }
      let(:authentication_double){ double(Google::Auth::ServiceAccountCredentials) }
      let(:directory_service_double){ double(Google::Apis::AdminDirectoryV1::DirectoryService)}
      let(:google_group_double) do
        double(Google::Apis::AdminDirectoryV1::Group,
               id: "0279ka6516ngz0s",
               email: google_group_email
              )
      end
      let(:group_settings_double){ double(Google::Apis::GroupssettingsV1::Groups) }
      let(:settings_service_double){ double(Google::Apis::GroupssettingsV1::GroupssettingsService) }
      let(:google_group_member_double){ double(Google::Apis::AdminDirectoryV1::Member)}
      let(:google_group_count){ GoogleGroup.count }

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

        # creating group
        allow(Google::Apis::AdminDirectoryV1::Group)
          .to receive(:new).and_return(google_group_double)
        allow(directory_service_double)
          .to receive(:insert_group).and_return(google_group_double)

        # setting group group permissions
        allow(Google::Apis::GroupssettingsV1::Groups)
          .to receive(:new).and_return(group_settings_double)
        allow(group_settings_double).to receive(:authorization=)
        allow(Google::Apis::GroupssettingsV1::GroupssettingsService)
          .to receive(:new).and_return(settings_service_double)
        allow(settings_service_double).to receive(:authorization=)
        allow(settings_service_double).to receive(:update_group) # <- expect!

        # adding member
        allow(Google::Apis::AdminDirectoryV1::Member)
          .to receive(:new).and_return(google_group_member_double)
        allow(directory_service_double).to receive(:insert_member)

        # count google groups
        google_group_count

        # fill out form!
        visit "/groups/#{fancy_group.id}/subgroups/new"
        perform_enqueued_jobs do
          fill_out_form(
            'Name' => 'Jawbreaker',
            'Description (may contain HTML)' => 'I want to be a boat, I want to learn to swim',
            'Zipcode (group)' => '90210',
            'First name' => 'herbert',
            'Last name' => 'stencil',
            'Password' => 'password',
            'Phone number' => '212-867-5309',
            'Email' => 'foo@bar.com',
            'Zipcode (personal)' => '90211'
          )
          click_button "Submit"
        end
      end

      it "creates a google group" do
        expect(Google::Apis::AdminDirectoryV1::Group)
          .to have_received(:new).with(email: Group.last.google_group_email,
                                       name: Group.last.name,
                                       description: GoogleAPI::CreateGoogleGroup::DESCRIPTION)

        expect(directory_service_double)
          .to have_received(:insert_group).with(google_group_double)
      end

      it "adds permissive settings to google group" do
        expect(settings_service_double)
          .to have_received(:update_group).with(google_group_email,
                                                group_settings_double)
      end

      it "adds member to google group" do
        expect(Google::Apis::AdminDirectoryV1::Member)
          .to have_received(:new).with(email: Person.last.email,
                                       role: GoogleAPI::Roles::OWNER)

        expect(directory_service_double)
          .to have_received(:insert_member).with(google_group_double.id,
                                                 google_group_member_double)
      end

      it "stores a record of the new google group" do
        GoogleGroup.count.must_equal(google_group_count + 1)
      end

      it "saves the google group's important attributes" do
        GoogleGroup.last.attributes.slice(*%w[group_id group_key email url])
          .must_equal(
            'group_id'  => Group.last.id,
            'group_key' => google_group_double.id,
            'email'     => google_group_email,
            'url'       => google_group_url
          )
      end
    end
  end
end
