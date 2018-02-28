require_relative "../../test_helper"

class CanSignupTest < ActiveSupport::TestCase

  let(:form){ custom_forms(:group_signup) }
  let(:group) { groups(:one) }
  let(:person){ people(:new_signup)}
  let(:person_attributes) do
    person.attributes.except('id').merge(
      'email_addresses_attributes' => [
        person.email_addresses.first.attributes.except('id').merge(
          'address' => 'foobar@example.com' # to avoid uniquness constraint
        )
      ],
      'phone_numbers_attributes' => [
        person.phone_numbers.first.attributes.except('id')
      ],
      'personal_addresses_attributes' => [
        person.personal_addresses.first.attributes.except('id')
      ]
    )
  end

  describe "instance methods" do
    it "provides a list of associated resources required by a form" do
      person.signup_resources_for(form)
        .must_equal([person.email_addresses,
                     person.phone_numbers,
                     person.personal_addresses])
    end
  end

  describe "class methods" do

    describe ".create_from_signup factory" do

      let(:person_count){ Person.count }
      let(:membership_count){ Membership.count }
      let(:contact_info_count){ count_contact_infos }
      let(:new_member){ Person.last }

      before do
        person_count; membership_count; contact_info_count

        Person.create_from_signup(form, group, person_attributes)
      end

      it "creates a new person" do
        Person.count.must_equal person_count + 1
      end

      it "creates a new Membership" do
        Membership.count.must_equal(membership_count + 1)
      end

      it "makes person a member of the group" do
        group.memberships.last.person.must_equal new_member
        new_member.memberships.last.group.must_equal group
      end

      it "saves the new member's contact info" do
        count_contact_infos.must_equal contact_info_count + 3
      end

      it "stores contact info as primary" do
        [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
          new_member.send(msg).first.primary?.must_equal true
        end
      end
    end

    private

    def count_contact_infos
      EmailAddress.count + PersonalAddress.count + PhoneNumber.count
    end
  end
end
