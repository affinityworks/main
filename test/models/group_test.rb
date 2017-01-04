require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "basic person associations" do
    one = groups(:one)
    assert_kind_of Group, one
    assert_kind_of AdvocacyCampaign, one.advocacy_campaigns.first
    assert_kind_of CanvassingEffort, one.canvassing_efforts.first
    assert_kind_of Petition, one.petitions.first
    assert_kind_of SharePage, one.share_pages.first
    assert_kind_of Form, one.forms.first
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
    assert_kind_of Person, one.members.first
    assert_kind_of Event, one.events.first
  end
end
