class Migration
  class << self
    def update_networks
      HashWithIndifferentAccess
        .new(Rails.configuration.networks)
        .values
        .each do |network_hash|
        Network
          .find_or_create_by(name: network_hash.fetch(:name))
          .tap do |network|
          network.update(
            members: network.members + network_hash.fetch(:groups, []).map do |group_hash|
              Group
                .find_or_create_by(name: group_hash.fetch(:name))
                .tap do |group|
                group.update(
                  network_memberships: group.network_memberships + [
                    NetworkMembership
                      .find_or_create_by(
                        group: group,
                        network: network
                      ).tap { |nm| nm.update( primary: true) }
                  ],
                  members: group.members + group_hash.fetch(:organizers, []).map do |person_hash|
                    Person
                      .find_or_create_by(
                        given_name: person_hash.fetch(:given_name),
                        family_name: person_hash.fetch(:family_name)
                      ).tap do |person|
                      person.update(
                        memberships: person.memberships + [
                          Membership
                            .find_or_create_by(
                              group: group,
                              person: person,
                            ).tap { |m| m.update( role: 'organizer' ) }
                        ],
                        email_addresses: person.email_addresses +
                        (person_hash.fetch('email', nil) ?
                          [
                            EmailAddress
                              .find_or_create_by(
                                address: person_hash.fetch('email'),
                              ).tap { |e| e.update(primary: true) }
                          ] :
                          [])
                      )
                    end
                  end
                )
              end
            end
          )
        end
      end
    end

    def backfill_signup_form_fields
      SignupForm.all.each do |sf|
        sf.person_input_group&.update!(required: %w[given_name family_name])
        sf.email_input_group&.update!(required: %w[address])
        sf.address_input_group&.update!(required: %w[postal_code])
        sf.phone_input_group&.update!(inputs: %w[number], required: [])
      end
    end
  end
end
