# == Schema Information
#
# Table name: addresses
#
#  id                :integer          not null, primary key
#  venue             :string
#  address_lines     :string
#  locality          :string
#  region            :string
#  postal_code       :string
#  country           :string
#  location_id       :integer
#  status            :string
#  primary           :boolean
#  address_type      :string
#  occupation        :string
#  person_id         :integer
#  type              :string
#  longitude         :float
#  latitude          :float
#  location_accuracy :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language          :string
#

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
