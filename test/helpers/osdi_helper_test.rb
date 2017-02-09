require 'test_helper'

class OsdiHelperTest < ActionView::TestCase
  test 'return OSDI identifier for model' do
    person = Person.new(id: 14)
    assert_equal 'osdi:person-14', osdi_identifier(person)
  end
end
