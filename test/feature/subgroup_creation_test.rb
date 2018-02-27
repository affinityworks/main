require_relative "../test_helper"

class SubgroupCreation < FeatureTest

  let(:group){ groups(:one) }
  RESOURCES = %w[group address person membership phone_number email_address signup_form].freeze

  before { visit "/groups/#{group.id}/subgroups/new" }

  describe "viewing group creation form" do
    it "has parent group's name in title" do
      page.must_have_content group.name
    end

    it "has fields for creating a group" do
      ['Name', 'Summary', 'Zipcode (group)'].each do |label|
        page.find("#group-fields input[placeholder='#{label}']").wont_be_nil
      end
    end

    it "has a large description text area" do
      page.find("textarea[placeholder='Description']").wont_be_nil
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
        page.find("#organizer-fields input[placeholder='#{label}']").wont_be_nil
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

    describe "with no errors" do
      before do
        RESOURCES.each { |r| send("#{r}_count") }
        fill_out_form(
          'Name' => 'Jawbreaker',
          'Description' => 'Early emo is the best emo',
          'Summary' => 'I want to be a boat, I want to learn to swim',
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

      it "redirects to subgroup signup page" do
        page.current_path.must_equal(
          "/groups/#{Group.last.id}/signup_forms/#{SignupForm.last.id}/signups/new"
        )
      end

      it "saves group info" do
        Group.last.attributes.slice(*%w[name description summary]).must_equal(
          'name' =>  "Jawbreaker",
          'description' => 'Early emo is the best emo',
          'summary' => 'I want to be a boat, I want to learn to swim'
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
        Person.last.encrypted_password.wont_be_nil
        Person.last.valid_password?("password")
      end

      it "saves organizer contact info" do
        Person.last.email_addresses.last.address.must_equal 'foo@bar.com'
        Person.last.phone_numbers.last.number.must_equal '212-867-5309'
        Person.last.personal_addresses.last.postal_code.must_equal '90211'

        # TODO: we should save new contact info as "primary"
        # Person.last.primary_email_address.must_equal 'foo@bar.com'
        # Person.last.primary_phone_number.must_equal '212-867-5309'
        # Person.last.primary_address.postal_code.must_equal '90211'
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
  end
end
