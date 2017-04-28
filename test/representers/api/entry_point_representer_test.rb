require 'test_helper'

class Api::EntryPointRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    JSON.parse(Api::EntryPointRepresenter.new(Api::EntryPoint.new).to_json)
  end
end
