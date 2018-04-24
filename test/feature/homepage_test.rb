require_relative "../test_helper"

class HomepageTest < FeatureTest
  let(:group){ groups(:fantastic_four) }
  let(:organizer){ people(:human_torch) }
  let(:member){ people(:the_thing) }

  describe "viewing homeage" do
    describe "as an organizer" do
      before do
        login_as organizer
        visit '/home'
      end

      it "shows a link to group dashboard page" do
        page.must_have_link group.name,
                            href: "/groups/#{group.id}/dashboard"
      end
    end

    describe "as a member" do
      before do
        login_as member
        visit '/home'
      end

      it "shows a link to group dashboard page" do
        page.must_have_link group.name,
                            href: "/groups/#{group.id}/dashboard"
      end

      it "navigates to group dashboard when i click on group name" do
        click_link group.name
        current_path.must_equal "/groups/#{group.id}/dashboard"
      end
    end
  end
end
