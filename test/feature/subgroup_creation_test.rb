require_relative "../test_helper"

class SubgroupCreation < FeatureTest

  let(:group){ groups(:one) }

  before { visit "/groups/#{group.id}/subgroups/new" }

  describe "viewing group creation form" do
    it "has parent group's name in title" do
      page.must_have_content group.name
    end

    it "has fields for creating a group" do
      skip
      ['name', 'description', 'zip code'].each do |label|
        page.must_have_content label
      end
    end
    it "has groups for creating an organizer"
  end

  describe "submitting signup form" do
    let(:group_count){ Group.count }
    let(:address_count){ Address.count }

    describe "with no errors" do
      before do
        group_count
        address_count
        fill_out_form(
          'group_name' => 'Jawbreaker',
          'group_description' => 'Early emo is the best emo',
          'group_location_attributes_postal_code' => '90210'
        )
        click_button "Submit"
      end

      it "creates a group" do
        Group.count.must_equal(group_count + 1)
      end

      it "creates an address" do
        Address.count.must_equal(address_count + 1)
      end

      it "creates an organizer"
      it "makers organizer a member of the group"
      it "etc"
    end
  end
end
