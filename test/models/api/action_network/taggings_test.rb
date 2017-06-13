require 'test_helper'

class Api::ActionNetwork::TaggingsTest < ActiveSupport::TestCase
  test '.import!' do
    group = Group.first
    person_uid = '636c4f79-2fde-4a6b-9ef3-276801f63315'
    tag = Tag.create(name: 'Testing tag')
    tag_uid = '480cd227-7490-44db-90ec-81cd47483745'
    TagOrigin.create(uid: tag_uid, tag: tag, origin: origins(:action_network))

    stub_request(:get, "https://actionnetwork.org/api/v2/tags/#{tag_uid}/taggings")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'taggings.json')))
    stub_request(:get, "https://actionnetwork.org/api/v2/people/#{person_uid}")
      .with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Osdi-Api-Token'=>'test-token', 'User-Agent'=>'Ruby'})
      .to_return(body: File.read(Rails.root.join('test', 'fixtures', 'files', 'person.json')))

    assert_difference 'Person.count', 1, 'Imports the person related with the tagging.' do
      Api::ActionNetwork::Taggings.import!(tag_uid, tag.name, group)
    end

    person = Person.last

    assert_includes person.tag_list, tag.name
  end
end
