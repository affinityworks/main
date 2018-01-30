# == Schema Information
#
# Table name: group_signup_forms
#
#  id              :integer          not null, primary key
#  group_id        :integer          not null
#  inputs          :string           default([]), is an Array
#  required_inputs :string           default([]), is an Array
#  button_text     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  form_id         :integer          not null
#

class GroupSignupForm < ApplicationRecord

  #
  # ASSOCIATIONS
  #

  belongs_to :group
  belongs_to :form

  accepts_nested_attributes_for :form

  #
  # DELEGATIONS
  #

  delegate :description, :title, :name, :call_to_action, to: :form

  #
  # VALIDATIONS
  #

  validates_presence_of [:group_id, :inputs]

  VALID_INPUTS = [
    'honorific_prefix',
    'given_name',
    'family_name',
    'additional_name',
    'honorific_suffix',
    'email_address', # nested field on EmailAddress
    'phone_number', # nested field on PhoneNumber
    'address_lines', # nested field on Address
    'locality', # nested field on Address
    'region', # nested field on Address
    'postal_code', # nested field on Address
    'country', # nested field on Address
    'address_type', # nested field on Address
    'birthdate',
    'occupation', # nested field on Address
    'employer',
    'gender',
    'gender_identity',
    'ethnicities',
    'languages_spoken',
    'party_identification',
  ].freeze

  validate :inputs_valid

  def inputs_valid
    if inputs.present?
      inputs.each do |input|
        unless VALID_INPUTS.include? input
          errors.add(:inputs, "must be one of: #{VALID_INPUTS}.join(', ')" )
        end
      end
    end
  end

  validate :required_inputs_valid

  def required_inputs_valid
    if required_inputs.present? && inputs.present?
      required_inputs.each do |input|
        unless inputs.include? input
          errors.add(:required_inputs, "must be one of: #{inputs.join(", ")}")
        end
      end
    end
  end

  #
  # ACCESSORS
  #

  def ordered_inputs
    VALID_INPUTS & inputs
  end
end
