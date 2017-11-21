require 'test_helper'

class Api::ActionNetwork::EventsTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first

    stub_request(:get, "https://actionnetwork.org/api/v2/events?filter=origin_system%20eq%20'Action%20Network'")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events.json')))

    stub_request(:get, "https://actionnetwork.org/api/v2/events?page=2")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events_page_2.json')))

    travel_to Time.zone.local(2001) do
      group.events.create!(
        title: 'TBD',
        status: 'confirmed',
        identifiers: ['action_network:a3c724db-2799-49a6-970a-7c3c0844645d']
      )
    end

    assert_difference 'Event.count', 2 do
      assert_difference 'EventAddress.count', 3 do
        Api::ActionNetwork::Events.import! group
      end
    end

    new_event = group.events.find_by(name: 'March 14th Rally')
    assert new_event.organizer
    assert new_event.creator

    assert new_event.location.venue.present?
    assert new_event.location.address_lines.present?
    assert new_event.location.locality.present?

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

    stub_request(:get, 'https://actionnetwork.org/api/v2/events')
      .with(headers: { 'OSDI-API-TOKEN' => group.an_api_key })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'events2.json')))

      travel_to Time.zone.local(2001) do
        new_event.updated_at = Time.now
        new_event.save
      end

    Api::ActionNetwork::Events.import! group

    new_event.reload

    assert_equal 'March 14th Rally', new_event.name
    assert_equal 'Lafayette Square', new_event.location.venue
  end
end
