module Api::IndependentResource
  extend ActiveSupport::Concern

  included do
    property :created_at, as: :created_date
    property :identifiers
    property :updated_at, as: :modified_date

    link :self do
      "/api/v1/#{ActiveModel::Naming.plural(represented)}/#{represented.id}"
    end
  end
end
