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

  test 'should save person without name' do
    Person.create!
  end

  test '#name' do
    assert_equal '', Person.new.name, '""'
    assert_equal 'Frank', Person.new(given_name: 'Frank').name, 'given_name only'
    assert_equal 'Ko', Person.new(family_name: 'Ko').name, 'family_name only'
    assert_equal 'Francis Ko', Person.new(given_name: 'Francis', family_name: 'Ko').name, 'name'
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

  test '#sanitize_email_addresses' do
    Person.new.sanitize_email_addresses

    person = Person.new(
      email_addresses: [
        EmailAddress.new(primary: true, address: ''),
        EmailAddress.new(primary: false, address: 'good.one@example.com'),
        EmailAddress.new(primary: false, address: '12@1.c')
      ]
    )
    person.sanitize_email_addresses
    assert_equal ['good.one@example.com'], person.email_addresses.map(&:address)
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

  test 'primary email_address may differ from #email' do
    person = Person.new(
      email: 'ls127@example.com',
      password: 'secret123',
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
    assert person.valid?, 'person with mismtached email addresses is valid'
  end

  test 'blank #email and primary email address is valid' do
    person = Person.new(
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
    assert person.valid?
  end

  test 'create with identifiers' do
    person = Person.create!(identifiers: ['sncc:123'])
    person.reload
    assert_equal ["advocacycommons:#{person.id}", 'sncc:123'], person.identifiers.sort, 'identifiers'
  end

  test '' do
    
  end
end
