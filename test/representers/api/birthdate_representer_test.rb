require 'test_helper'

class Api::BirthdateRepresenterTest < ActiveSupport::TestCase
  test 'to_json' do
    birthdate = Time.zone.local(1972, 12, 31)

    json = JSON.parse(Api::BirthdateRepresenter.new(birthdate).to_json)

    assert_equal 12, json['month'], 'month'
    assert_equal 31, json['day'], 'day'
    assert_equal 1972, json['year'], 'year'
  end
end
