require 'test_helper'

class AdvocacyCampaignTest < ActiveSupport::TestCase
  test "basic associations" do
    one = advocacy_campaigns(:one)
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.modified_by
  end

  test "should not save address with no data" do
    campaign = AdvocacyCampaign.new
    assert_not campaign.save
  end

  test "should have association with outreach" do
    out = outreaches(:one)

    assert_kind_of AdvocacyCampaign, out.advocacy_campaign
    assert_kind_of Outreach, out.advocacy_campaign.outreaches.first

  end
end
