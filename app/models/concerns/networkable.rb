module Networkable
  extend ActiveSupport::Concern

  included do
    # ASSOCIATIONS
    has_many :network_memberships
    has_many :networks, through: :network_memberships

    # NESTED ATTRIBUTES
    accepts_nested_attributes_for :network_memberships

    # ACCESSORS
    def primary_network
      network_memberships&.primary&.first&.network
    end

    def network_memberships_attributes
      network_memberships.map do |nm|
        nm.attributes.except('id', 'created_at', 'updated_at')
      end
    end
  end
end
