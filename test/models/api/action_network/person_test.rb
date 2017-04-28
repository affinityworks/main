require 'test_helper'

class Api::ActionNetwork::PersonTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first
    person_uuid = '06d13a33-6824-493b-a922-95e793f269d3'

    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uuid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    assert_difference 'group.members.count', 1, 'Creates a new person.' do
      Api::ActionNetwork::Person.import!(person_uuid, group)
    end

    assert_no_difference 'group.members.count', 'Does not create already created people.' do
      Api::ActionNetwork::Person.import!(person_uuid, group)
    end
  end
end
