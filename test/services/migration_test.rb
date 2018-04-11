require_relative "../test_helper"

class MigrationTest < ActiveSupport::TestCase
  describe "#update_networks" do
    before { Migration.update_networks }

    describe "a new network w/ groups & organizers is added to config files" do
      let(:against_the_day){ Network.find_by_name('Against The Day') }
      let(:organizers){ against_the_day.members.map(&:members).flatten }

      it "creates the network" do
        against_the_day.wont_be_nil
      end

      it "creates the groups and adds them to the network" do
        against_the_day.members.map(&:name).sort
          .must_equal(['The Chums Of Chance', 'The Balkan Anarchists'].sort)
      end

      it "is idempotent" do
        against_the_day.members.count.must_equal 2
        Migration.update_networks
        against_the_day.members.count.must_equal 2
      end

      it "gives each group a primary membership in the network" do
        against_the_day
          .members
          .map(&:primary_network)
          .must_equal(Array.new(2){ against_the_day })
      end

      it "creates the organizers and adds them to the group" do
        organizers
          .map(&:attributes)
          .map{ |attrs| attrs.slice('given_name', 'family_name') }.to_set
          .must_equal([{ 'given_name'  => 'Chick',
                         'family_name' => 'Counterfly' },
                       { 'given_name'  => 'Darby',
                         'family_name' => 'Suckling' },
                       { 'given_name'  => 'Yashmeen',
                         'family_name' => 'Halfcourt'},
                       { 'given_name'  => 'Cyprian',
                         'family_name' => 'Latewood' }].to_set)
      end

      it "gives each new organizer the correct role" do
        organizers
          .map(&:memberships)
          .flatten
          .each { |m| m.role.must_equal 'organizer' }
      end

      it "creates the email addresses and adds them to the organizers" do
        organizers
          .map(&:email_addresses)
          .flatten
          .map(&:attributes)
          .map{ |attrs| attrs.slice('address', 'primary') }.to_set
          .must_equal([{ 'address' => 'chick@counterfly.net',
                         'primary' => true },
                       { 'address' => 'darby@suckling.net',
                         'primary' => true },
                       { 'address' => 'yashmeen@halfcourt.net',
                         'primary' => true },
                       { 'address' => 'cyprian@latewood.net',
                         'primary' => true }].to_set)
      end
    end

    describe "a new group is added to an existing network in config files" do
      it "does not create a new network" do
        Network.where(name: 'The Avengers').count.must_equal 1
      end

      it "creates the group and adds it to the network" do
        Group.find_by_name('Wakanda').wont_be_nil
        Network
          .find_by_name('The Avengers')
          .members
          .map(&:name)
          .must_include('Wakanda')
      end

      it "does not erase existing network memberships" do
        Network
          .find_by_name('The Avengers')
          .members
          .must_include(groups(:fantastic_four))
      end

      it "is idempotent" do
        Group.where(name: 'Wakanda').count.must_equal 1
        Migration.update_networks
        Group.where(name: 'Wakanda').count.must_equal 1
      end
    end

    describe "a new organizer is added to an existing group in the config files" do
      it "does not create a new group" do
        Group
          .where(name: 'Ohio Chapter of National Network')
          .count
          .must_equal 1
      end

      it "creates a new organizer and adds her to the group" do
        serious_person = Person.find_by(given_name: 'Serious', family_name: 'Person')
        groups(:ohio_chapter).members.must_include(serious_person)
      end

      it "is idempotent" do
        groups(:ohio_chapter).members.count.must_equal 2
        Migration.update_networks
        groups(:ohio_chapter).members.count.must_equal 2
      end
    end

    describe "a new email address is added to an existing organizer" do
      let(:person){ Person.find_by(given_name: 'Trouble', family_name: 'Maker' )}
      let(:email){ EmailAddress.find_by_address('troublemaker@riseup.net') }

      it "does not create a new organizer" do
        Person
          .where(given_name: 'Trouble', family_name: 'Maker')
          .count
          .must_equal 1
      end

      it "does not override existing email addresses" do
        person.email_addresses.must_include(email_addresses(:troublemaker))
      end

      it "creates a new email and makes it the organizer's primary email address" do
        person.primary_email_address.must_equal email.address
      end

      it "is idempotent" do
        person.email_addresses.count.must_equal 2
        Migration.update_networks
        person.email_addresses.count.must_equal 2
      end
    end

    describe "a group with multiple memberships is described in the configs" do
      it "does not have its secondary memberships erased" do
        groups(:ohio_chapter).network_memberships.count.must_equal 2
      end
    end
  end

  describe "#backfill_signup_form_fields" do
    let(:group){ groups(:one) }

    it "updates legacy signup form fields to match new requirements" do
      legacy_form = SignupForm.create!(
        group: group,
        form: Form.new(
          name: "#{group.name}_default_signup_form",
          title: "#{group.name}",
          description: group.description || "<div></div>",
          call_to_action: "get involved"
        ),
        person_input_group: PersonInputGroup.new(
          inputs: %w[given_name family_name],
        ),
        email_input_group: EmailInputGroup.new(
          inputs: %w[address],
        ),
        address_input_group: AddressInputGroup.new(
          inputs: %w[postal_code],
        ),
        phone_input_group: PhoneInputGroup.new
      )
      Migration.backfill_signup_form_fields
      legacy_form.reload

      legacy_form.person_input_group.required.must_equal %w[given_name family_name]
      legacy_form.email_input_group.required.must_equal %w[address]
      legacy_form.address_input_group.required.must_equal %w[postal_code]
      legacy_form.phone_input_group.inputs.must_equal %w[number]
      legacy_form.phone_input_group.required.must_be_empty
    end
  end
end
