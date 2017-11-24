require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'post #create' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    group = groups(:test)
    post tags_url(resource_type: 'group', resource_id: group.id, tag_name: tag_name), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal group.reload.tags.last.name, json['name']
    assert_equal group.reload.tags.last.id, json['id']
  end

  test 'post #create with invlalid type' do
    person = people(:organizer)
    sign_in person

    post tags_url(resource_type: 'invalid', resource_id: 1, tag_name: 'tag'), as: :json
    assert_response :not_found
  end

  test 'delete #destroy' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    group = groups(:test)
    group.tag_list.add('example')
    group.save

    assert_equal group.reload.tag_list, ['example']
    assert_difference 'Tag.count', 0 do
      delete tag_url(resource_type: 'group', resource_id: group.id, id: group.tags.first.id), as: :json
      assert_empty group.reload.tag_list
    end



    assert_response :success
  end
end
