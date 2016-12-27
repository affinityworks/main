class Address < ApplicationRecord
  belongs_to :person
  acts_as_mappable :default_units => :miles,
                 :default_formula => :sphere,
                 :distance_field_name => :distance,
                 :lat_column_name => :latitude,
                 :lng_column_name => :longitude

  def location
    return( {'latitude' => latitude, 'longitude' => longitude})
  end
end
