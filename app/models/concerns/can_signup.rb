module CanSignup
  extend ActiveSupport::Concern
  RESOURCE_COLLECTIONS = [:email_addresses,
                          :personal_addresses,
                          :phone_numbers].freeze

  included do
    def build_signup_resources
      RESOURCE_COLLECTIONS.each do |resource_collection|
        if send(resource_collection).empty?
          send(resource_collection).build(primary: true)
        end
      end
    end
  end

  class_methods do
    def build_for_signup
      Person.new.tap { |p| p.build_signup_resources }
    end

    def create_from_signup(form, group, person_attrs)
      Person.create(
        person_attrs.merge(
          memberships_attributes: [{ role: 'member', group: group }]
          # TODO: (aguestuser|28-Feb-2018)
          # to track signups, include nested attrs w/ something like:
          # signup_attributes: { source: form }
        )
      )
    end
  end
end
