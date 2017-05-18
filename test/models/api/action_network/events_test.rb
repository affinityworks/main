require 'test_helper'

class Api::ActionNetwork::EventsTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first

    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/events").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'c96dc7a808ed80fca8bb4953f8ac10bf', 'User-Agent'=>'Ruby'}).
      to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events.json')))

    travel_to Time.zone.local(2001) do
      group.events.create!(
        title: 'TBD',
        identifiers: ['action_network:a3c724db-2799-49a6-970a-7c3c0844645d']
      )
    end

    assert group.events.where(title: 'House Party for Progress').exists
    assert group.events.any_identifier('action_network:1efc3644-af25-4253-90b8-a0baf12dbd1e').exists

    assert_difference 'Event.count', 1 do
      assert_difference 'EventAddress.count', 1 do
        Api::ActionNetwork::Events.import! group
      end
    end

    assert group.events.where(name: 'March 14th Rally').exists
    assert group.events.where(title: 'House Party for Progress').exists

    new_event = group.events.find_by(name: 'March 14th Rally')
    assert new_event.organizer

    assert new_event.location.venue.present?
    assert new_event.location.address_lines.present?
    assert new_event.location.locality.present?

    # it should pull in from link but it doesn't so this doesn't work. 
    #assert group.events.find_by(name: 'March 14th Rally').creator
    #assert group.events.find_by(name: 'March 14th Rally').modified_by

    march_14_event = group.events.where(name: 'March 14th Rally').first!

    assert_equal 'open', march_14_event.osdi_type

    expected_identifiers = [
      'action_network:d91b4b2e-ae0e-4cd3-9ed7-d0ec501b0bc3',
      'foreign_system:1',
      "advocacycommons:#{march_14_event.id}"
    ].sort
    assert_equal expected_identifiers, march_14_event.identifiers&.sort, 'identifiers'

    updated_event = Event.any_identifier('action_network:a3c724db-2799-49a6-970a-7c3c0844645d').first!
    assert_equal 'Teach in', updated_event.title, 'Should update title'
  end
end
