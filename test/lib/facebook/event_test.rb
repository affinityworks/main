require 'test_helper'
require 'minitest/mock'

class Facebook::EventTest < ActiveSupport::TestCase
  test '#find' do
    event_id = '123456'
    url = "https://www.facebook.com/events/#{event_id}"
    organizer_identity = identities(:organizer)
    api_agent = Minitest::Mock.new

    params = [
      "/#{event_id}",
      { access_token: organizer_identity.access_token }
    ]

    2.times { api_agent.expect :get, {}, params }


    #i'm really not sure waht's going on here - rabble
    Facebook::ApiAgent.stub :new, api_agent do
      assert Facebook::Event.new(:identity => organizer_identity).find_by_url(url)
      assert Facebook::Event.new(:identity => organizer_identity).find_by_event_id(event_id)
    end
  end
end
