require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test '.type_event' do
    one = events(:one)
    one.tag_list.add('tag_1', 'tag_2', 'tag_3')
    one.save
    two = events(:two)
    two.tag_list.add('tag_4', 'tag_5', 'tag_6')
    two.save
    tags = one.reload.tags.sort.pluck(:name) + two.reload.tags.sort.pluck(:name)
    assert_equal Tag.type_event.sort.pluck(:name), tags
  end

  test '.type_membership' do
    one = memberships(:one)
    one.tag_list.add('tag_1', 'tag_2', 'tag_3')
    one.save
    two = memberships(:two)
    two.tag_list.add('tag_4', 'tag_5', 'tag_6')
    two.save
    tags = one.reload.tags.sort.pluck(:name) + two.reload.tags.sort.pluck(:name)
    assert_equal Tag.type_membership.sort.pluck(:name), tags
  end
end
