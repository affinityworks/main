class Address < ApplicationRecord
  include ArelHelpers::ArelTable
  serialize :address_lines, Array
  belongs_to :person
  acts_as_mappable default_units: :miles,
                   default_formula: :sphere,
                   distance_field_name: :distance,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

  def location
    { latitude: latitude, longitude: longitude }
  end

  #todo add polymorphic assocaitions for personal adderss / employer / event address
end
