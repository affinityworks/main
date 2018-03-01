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
      ['Name', 'Zipcode (group)'].each do |label|
        page.find("input[placeholder='#{label}']").wont_be_nil
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
        page.find("input[placeholder='#{label}']").wont_be_nil
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
    let(:mail_delivery){ ActionMailer::MessageDelivery }

    describe "with no errors" do
      before do
        RESOURCES.each { |r| send("#{r}_count") }
        # allow(OrganizerMailer).to receive(:new_subgroup_email).and_return(mail_delivery)
        # allow(mail_delivery).to receive(:deliver_later)
        fill_out_form(
          'Name' => 'Jawbreaker',
          'Description' => 'I want to be a boat, I want to learn to swim',
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
        # write this in minitest style! ugh!
        # expect(OrganizerMailer)
        #  .to have_received(:new_subgroup_email)
        #       .with(last_person, Group.last, SignupForm.last)
        # expect(mail_delivery).to have_received(:deliver_later)
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
