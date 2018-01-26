# == Schema Information
#
# Table name: group_signup_forms
#
#  id              :integer          not null, primary key
#  group_id        :integer
#  person_fields   :string           default([]), is an Array
#  required_fields :string           default([]), is an Array
#  page_text       :string           not null
#  button_text     :string           not null
#  prompt_text     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class GroupSignupForm < ApplicationRecord

  #
  # ASSOCIATIONS
  #

  belongs_to :group

  #
  # VALIDATIONS
  #

  validates_presence_of [:admin_title,
                         :button_text,
                         :display_title,
                         :group_id,
                         :page_text,
                         :person_fields,
                         :prompt_text]

  VALID_PERSON_FIELDS = ['address_lines', # nested field on Address
                         'address_type', # nested field on Address
                         'birthdate',
                         'country', # nested field on Address
                         'email_address', # nested field on EmailAddress
                         # 'email_addresses', # what `form_for` expects
                         'employer',
                         'ethnicities',
                         'family_name',
                         'gender',
                         'gender_identity',
                         'given_name',
                         'honorific_prefix',
                         'honorific_suffix',
                         'languages_spoken',
                         'locality', # nested field on Address
                         'occupation', # nested field on Address
                         'party_identification',
                         'phone_number', # nested field on PhoneNumber
                         # 'phone_numbers', # what `form_for` expects
                         'postal_code', # nested field on Address
                         'region', # nested field on Address
                         'additional_name'].freeze

  validate :person_fields_valid

  def person_fields_valid
    if person_fields.present?
      person_fields.each do |field|
        unless VALID_PERSON_FIELDS.include? field
          errors.add(:person_fields, "must be one of: #{VALID_PERSON_FIELDS}.join(', ')" )
        end
      end
    end
  end

  validate :required_fields_valid

  def required_fields_valid
    if required_fields.present? && person_fields.present?
      required_fields.each do |field|
        unless person_fields.include? field
          errors.add(:required_fields, "must be one of: #{person_fields}")
        end
      end
    end
  end

  validate :page_text_valid

  def page_text_valid
    if page_text.present?
      doc = Nokogiri::HTML(page_text){ |config| config.strict }
      if doc.errors.any? || doc.css("script").any?
        errors.add(:page_text, "must be valid HTML with no JavaScript")
      end
    end
  end

end
