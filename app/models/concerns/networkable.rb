module Networkable
  extend ActiveSupport::Concern

  included do
    # ASSOCIATIONS
    has_many :network_memberships
    has_many :networks, through: :network_memberships

    # ACCESSORS
    def primary_network
      network_memberships.primary.first.network
    end
  end
end
