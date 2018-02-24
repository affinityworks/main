require_relative "../test_helper"

class SubgroupCreation < FeatureTest

  let(:group){ groups(:one) }

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

    describe "with no errors" do
      before do
        group_count; address_count; person_count; membership_count; phone_number_count; email_address_count
        fill_out_form(
          'Name' => 'Jawbreaker',
          'Description' => 'Early emo is the best emo',
          'Zipcode (group)' => '90210',
          'First name' => 'herbert',
          'Last name' => 'stencil',
          'Password' => 'password',
          'Phone number' => '212-867-5309',
          'Email' => 'foo@bar.com',
          'Zipcode (personal)' => '90210'
        )
        click_button "Submit"
      end

      %w[group person membership phone_number email_address].each do |resource|
        it "creates a #{resource}" do
          resource.camelize.constantize.count
            .must_equal(send("#{resource}_count") + 1)
        end

        it "creates 2 addresses" do
          Address.count.must_equal(address_count + 1)
        end
      end
    end

    describe "with errors" do
      before do
        group_count; address_count; person_count; membership_count; phone_number_count; email_address_count
        fill_out_form({})
        click_button "Submit"
      end

      it "does not create any resources" do
        %w[group address person membership phone_number email_address].each do |resource|
          resource.camelize.constantize.count
            .must_equal(send("#{resource}_count"))
        end
      end

      it "displays errors" do
        page.must_have_content "error"
      end
    end
  end
end
