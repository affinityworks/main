require 'test_helper'

class Api::ActionNetwork::PeopleTest < ActiveSupport::TestCase
  test '.import!' do
    stub_request(:get, 'https://actionnetwork.org/api/v2/people')
      .with(headers: { 'OSDI-API-TOKEN' => 'test-token' })
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'people.json')))

    assert_difference 'Person.count', 1 do
      Api::ActionNetwork::People.import!
    end

    # TODO: assert non-AN person unchanged
    # TODO: assert new person added correctly
    # TODO: assert unchanged person not updated
    # TODO: assert updated person was updated
  end
end
