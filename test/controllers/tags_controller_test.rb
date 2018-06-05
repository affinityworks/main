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

  describe 'delete #destroy' do
    let(:tag_count){ Tag.count }

    before do
      person = people(:organizer)
      sign_in person

      tag_name = 'example'
      @group = groups(:test)
      @group.tag_list.add('example')
      @group.save
    end

    describe 'tag has one has tagging' do
      before do
        tag_count
        delete tag_url(resource_type: 'group', resource_id: @group.id, id: @group.tags.first.id), as: :json
      end

      it "removes a tagging" do
        @group.reload.tag_list.must_be_empty
      end

      it "removes the tag" do
        Tag.count.must_equal(tag_count - 1)
      end
    end

    describe 'tag has multiple taggings' do
      before do
        group_two = groups(:two)
        group_two.tag_list.add('example')
        group_two.save

        tag_count
        delete tag_url(resource_type: 'group', resource_id: @group.id, id: @group.tags.first.id), as: :json
      end

      it "removes a tagging" do
        @group.reload.tag_list.must_be_empty
      end

      it "does not remove the tag" do
        Tag.count.must_equal tag_count
      end
    end
  end
end
