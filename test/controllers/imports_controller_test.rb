require 'test_helper'
require 'minitest/mock'

class ImportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'get #find' do
    person = Person.create(given_name: 'example')
    EmailAddress.create(address: 'example@example.com', person: person)
    sign_in person
    url = 'https://www.facebook.com/123465'

    get find_imports_url(remote_event_url: url), as: :json
    assert_redirected_to '/events'

    person = Person.first
    sign_in person

    remote_event = { 'name' => 'Name', 'start_time' => Date.today.to_s }
    facebook_agent = Minitest::Mock.new
    facebook_agent.expect :find, remote_event, [url]
    event = Event.create(start_date: Date.today, status: 'Status')
    event.groups.push(Group.first)

    Facebook::Event.stub :new, facebook_agent do
      get find_imports_url(remote_event_url: url), as: :json
      json = JSON.parse(@response.body)
      assert_equal 1, json['events']['data'].size
      assert_equal event.id, json['events']['data'].first['id'].to_i
      assert_equal remote_event['name'], json['remote_event']['name']
    end
  end
end
