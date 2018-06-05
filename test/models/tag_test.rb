require 'test_helper'

class EventTest < ActiveSupport::TestCase
  describe '.type_event' do
    specify do
      one = events(:one)
      one.tag_list.add('tag_1', 'tag_2', 'tag_3')
      one.save
      two = events(:two)
      two.tag_list.add('tag_4', 'tag_5', 'tag_6')
      two.save
      tags = one.reload.tags.sort.pluck(:name) + two.reload.tags.sort.pluck(:name)
      assert_equal Tag.type_event.sort.pluck(:name), tags
    end
  end

  describe '.type_membership' do
    specify do
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

  describe '.type_membership_with_ids' do
    it 'only returns tags associated with memberships in group' do
      membership = memberships(:one)
      membership.tag_list.add('tag_1', 'tag_2', 'tag_3')
      membership.save

      membership_two = memberships(:two)
      membership_two.tag_list.add('tag_4', 'tag_5', 'tag_6')
      membership_two.save

      Tag.type_membership_with_ids(groups(:one).memberships.pluck(:id)).count.must_equal 3
    end
  end
end
