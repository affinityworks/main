require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "basic person associations" do
    one = people(:one)
    assert_kind_of( Person, one )
    assert_kind_of EmailAddress, one.email_address
    assert_kind_of PhoneNumber, one.phone_numbers.first
    assert_kind_of Profile, one.profiles.first
    assert_kind_of Submission, one.submissions.first
    assert_kind_of Attendance, one.attendances.first
    assert_kind_of Event, one.events.first
    assert_kind_of Address, one.personal_addresses.first
    assert_kind_of Address, one.employer_address

    #todo add check for making sure polymorphism on adresses works.
  end

  test "should not save person without name" do
    person = Person.new
    assert_not person.save
  end

  test "membership in groups" do
    one = people(:one)
    assert_kind_of Group, one.groups.first
  end
end
