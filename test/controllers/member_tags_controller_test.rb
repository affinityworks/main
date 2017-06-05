require 'test_helper'

class MembershipTagsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'post #create' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    membership = person.memberships.first
    post membership_tags_url(membership_id: membership.id, tag_name: tag_name), as: :json
    assert_response :success
    json = JSON.parse(response.body)

    assert_equal membership.reload.tags.last.name, json['name']
    assert_equal membership.reload.tags.last.id, json['id']
  end

  test 'delete #destroy' do
    person = people(:organizer)
    sign_in person

    tag_name = 'example'
    membership = person.memberships.first
    membership.tag_list.add('example')
    membership.save

    assert_difference 'membership.tags.count', -1 do
      delete membership_tag_url(membership_id: membership.id, id: membership.tags.first.id), as: :json
    end
  end
end
