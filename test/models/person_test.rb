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

  test 'email addresses' do
    Person.create!(
      password: 'secret123',
      email_addresses: [
        EmailAddress.new(primary: true, address: 'lisa@example.com'),
        EmailAddress.new(primary: false, address: 'ls127@aol.com')
      ]
    )
  end


  test 'reading email address' do
    one = people(:one)
    assert_equal one.email, one.email_addresses.first.address
  end


    test 'writig email address' do
      one = people(:one)
      one.email="somethingelse@gmail.com"
      assert_equal 'somethingelse@gmail.com', one.email
      assert_equal 'somethingelse@gmail.com', one.email_addresses.first.address
    end


  test 'create with identifiers' do
    person = Person.create!(identifiers: ['sncc:123'])
    person.reload
    assert_equal ["advocacycommons:#{person.id}", 'sncc:123'], person.identifiers.sort, 'identifiers'
  end

  test 'attended_group_events' do
    person = Person.create(:given_name=>"Random person")
    group_event_attended = Attendance.create(attended: true, person: person, event: Event.first)
    Attendance.create(attended: true, person: person, event: Event.last)
    assert_equal person.attended_group_events(Group.first), [group_event_attended]
  end
end
