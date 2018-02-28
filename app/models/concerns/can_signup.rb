module CanSignup
  extend ActiveSupport::Concern

  included do

    def signup_resources_for(form)
      form.nested_input_groups.map { |input_group| send(input_group.resource) }
    end

    def build_signup_resources_for(form)
      signup_resources_for(form).each do |resources|
        resources.build(primary: true) if resources.empty?
      end
    end
  end

  class_methods do

    def build_for_signup(form)
      Person.new.tap { |p| p.build_signup_resources_for form }
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
