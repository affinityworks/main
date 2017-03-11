require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'basic person associations' do
    one = people(:one)
    assert_kind_of Person, one
    assert_kind_of EmailAddress, one.email_addresses.first
    assert_kind_of PhoneNumber, one.phone_numbers.first
    assert_kind_of Profile, one.profiles.first
    assert_kind_of Submission, one.submissions.first
    assert_kind_of Attendance, one.attendances.first
    assert_kind_of Event, one.events.first
    assert_kind_of Address, one.personal_addresses.first
    assert_kind_of Address, one.employer_address
  end

  test 'should not save person without name' do
    person = Person.new
    assert_not person.save
  end

  test 'membership in groups' do
    one = people(:one)
    assert_kind_of Group, one.groups.first
  end

  test 'addresses' do
    # Need to rename PersonalAddress to PostalAddress
    assert_raise(NoMethodError) do
      Person.create!(
        employer_address: EmployerAddress.new,
        personal_addresses: PersonalAddress.new
      )
    end
  end

  test 'email + email addresses' do
    Person.create!(
      email: 'lisa@example.com',
      password: 'secret123',
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
  end

  test 'primary email must match #email' do
    person = Person.new(
      email: 'ls127@example.com',
      password: 'secret123',
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
    assert !person.valid?, 'person with mismtached email addresses should be invalid'
  end

  test '#email must be set to primary email address' do
    person = Person.new(
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
    assert !person.valid?
  end
end
