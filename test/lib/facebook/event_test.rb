require 'test_helper'
require 'minitest/mock'

class Facebook::EventTest < ActiveSupport::TestCase
  test '#find' do
    event_id = '123456'
    url = "https://www.facebook.com/events/#{event_id}"

    api_agent = Minitest::Mock.new

    params = [
      "/#{event_id}",
      { access_token: Identity.last.access_token }
    ]

    2.times { api_agent.expect :get, {}, params }

    Facebook::ApiAgent.stub :new, api_agent do
      assert Facebook::Event.new(Identity.last).find(url)
      assert Facebook::Event.new(Identity.last).find(event_id)
    end
  end
end
