require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test 'basic associations' do
    one = events(:one)
    assert_kind_of TicketLevel, one.ticket_levels.first
    assert_kind_of Address, one.location
    assert_kind_of Person, one.creator
    assert_kind_of Person, one.organizer
    assert_kind_of Person, one.modified_by
    assert_kind_of Attendance, one.attendances.first
    assert_kind_of Reminder, one.reminders.first
  end

  test '#identifier' do
    event = Event.new
    assert_nil event.identifier('action_network')

    event = Event.new(identifiers: ['advocacycommons:3'])
    assert_nil event.identifier('action_network')
    assert_equal 'advocacycommons:3', event.identifier('advocacycommons')

    event = Event.new(identifiers: ['advocacycommons:3', 'action_network:100-200-abc'])
    assert_equal 'action_network:100-200-abc', event.identifier('action_network')
    assert_equal 'advocacycommons:3', event.identifier('advocacycommons')
    assert_nil event.identifier('foo')
  end

  test '#identifier_id' do
    event = Event.new
    assert_nil event.identifier_id('action_network')

    event = Event.new(identifiers: ['advocacycommons:3'])
    assert_nil event.identifier_id('action_network')
    assert_equal '3', event.identifier_id('advocacycommons')

    event = Event.new(identifiers: ['advocacycommons:3', 'action_network:100-200-abc'])
    assert_equal '100-200-abc', event.identifier_id('action_network')
    assert_equal '3', event.identifier_id('advocacycommons')
    assert_nil event.identifier_id('foo')
  end
end
