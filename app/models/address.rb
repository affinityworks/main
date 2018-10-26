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

  VALID_STATES = %w[ AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS
                     KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY
                     NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV
                     WI WY AS DC FM GU MH MP PW PR VI ]

  POSTAL_CODE_FORMAT = /\A[0-9|-]*\z/

  include ArelHelpers::ArelTable

  serialize :address_lines, Array

  belongs_to :person, optional: true

  validates :region,
            inclusion: { in: VALID_STATES + [nil, ""],
                         message: "'%{value}' must be one of: #{VALID_STATES.join(', ')}", }

  validates :postal_code,
            format: { with: POSTAL_CODE_FORMAT,
                      message: "'%{value}' is not a valid zip code" }


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
