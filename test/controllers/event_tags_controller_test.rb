require 'test_helper'

class EventTagsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'post #create' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    event = events(:test)
    post event_tags_url(event_id: event.id, tag_name: tag_name), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal event.reload.tags.last.name, json['name']
    assert_equal event.reload.tags.last.id, json['id']
  end

  test 'delete #destroy' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    event = events(:test)
    event.tag_list.add('example')
    event.save

    assert_difference 'event.tags.count', -1 do
      delete event_tag_url(event_id: event.id, id: event.tags.first.id), as: :json
    end
  end
end
