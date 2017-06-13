require 'test_helper'

class Api::ActionNetwork::TagsTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first
    tag_uid = '480cd227-7490-44db-90ec-81cd47483745'
    tag_name = 'testing'

    person_uid = '636c4f79-2fde-4a6b-9ef3-276801f63315'

    stub_request(:get, "https://actionnetwork.org/api/v2/tags")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'tags.json')))
    stub_request(:get, "https://actionnetwork.org/api/v2/tags/#{tag_uid}/taggings")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'taggings.json')))
    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    assert_difference 'Tag.count', 1, 'Creates a new tag.' do
      Api::ActionNetwork::Tags.import!(group)
    end

    tag = Tag.last
    assert_equal "Testing Tag", tag.name
    assert_equal tag_uid, tag.tag_origins.first.uid
  end
end
