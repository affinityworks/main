require 'test_helper'

class GoogleGroupTest < ActiveSupport::TestCase
  let(:group){ groups(:ohio_chapter) }
  let(:google_group){ google_groups(:ohio_chapter) }

  describe "validations" do
    let(:gg){ GoogleGroup.new }

    specify{ gg.wont have_valid(:group_id).when(nil) }
    specify{ gg.wont have_valid(:group_key).when(nil) }
    specify{ gg.wont have_valid(:email).when(nil) }
    specify{ gg.wont have_valid(:url).when(nil) }
  end

  describe "associations" do
    specify { google_group.group.must_be_instance_of(Group) }

    it "deletes the google group when deleting the parent group" do
      assert_difference ->{GoogleGroup.count}, -1 do
        group.destroy!
      end
    end
  end
end
