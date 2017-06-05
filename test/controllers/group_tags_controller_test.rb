require 'test_helper'

class GroupTagsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'post #create' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    group = groups(:test)
    post group_tags_url(group_id: group.id, tag_name: tag_name), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal group.reload.tags.last.name, json['name']
    assert_equal group.reload.tags.last.id, json['id']
  end

  test 'delete #destroy' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    group = groups(:test)
    group.tag_list.add('example')
    group.save

    assert_difference 'group.tags.count', -1 do
      delete group_tag_url(group_id: group.id, id: group.tags.first.id), as: :json
    end
  end
end
