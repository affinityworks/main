require 'test_helper'

class OutreachTest < ActiveSupport::TestCase

  test "should have association with advocacy_campaigns" do
    out = outreaches(:one)

    assert_kind_of Person, out.person
    assert_kind_of ReferrerData, out.referrer_data

    assert_kind_of AdvocacyCampaign, out.advocacy_campaign
    assert_kind_of ActiveRecord::Associations::CollectionProxy, out.advocacy_campaign.outreaches
    assert_kind_of Outreach, out.advocacy_campaign.outreaches.first

  end

end
