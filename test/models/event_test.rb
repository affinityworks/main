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

  test '.add_attendance_counts' do
    events = Event.all
    Event.add_attendance_counts(events)

    #assert_equal 2, events.detect { |e| e.id == 1 }.invited_count
    assert_equal 2, events.detect { |e| e.id == 1 }.rsvp_count
    assert_equal 0, events.detect { |e| e.id == 1 }.attended_count

    #assert_equal 4, events.detect { |e| e.id == 2 }.invited_count
    assert_equal 0, events.detect { |e| e.id == 2 }.rsvp_count
    assert_equal 0, events.detect { |e| e.id == 2 }.attended_count

    #assert_equal 4, events.detect { |e| e.id == 2 }.invited_count
    assert_equal 4, events.detect { |e| e.id == 3 }.rsvp_count
    assert_equal 2, events.detect { |e| e.id == 3 }.attended_count
  end

  test '.upcoming' do
    ended_event = Event.create(start_date: 2.days.ago)
    upcoming_event_1 = Event.create(start_date: Date.today)
    upcoming_event_2 = Event.create(start_date: Date.today + 2.days)
    future_event = Event.create(start_date: Date.today + (Event::UPCOMING_EVENTS_DAYS + 1).days)

    assert_includes Event.upcoming, upcoming_event_1
    assert_includes Event.upcoming, upcoming_event_2
  end

  test '.start' do
    Event.all.each {|event| event.destroy}
    
    ended_event = Event.create(start_date: 2.days.ago, status: 'status')
    event_1 = Event.create(start_date: Date.today, status: 'status')
    event_2 = Event.create(start_date: Date.today + 1.days, status: 'status')

    assert_equal [event_1], Event.start(Date.today)
  end
end
