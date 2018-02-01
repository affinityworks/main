# == Schema Information
#
# Table name: form_input_groups
#
#  id             :integer          not null, primary key
#  type           :string           not null
#  custom_form_id :integer
#  inputs         :string           default([]), is an Array
#  required       :string           default([]), is an Array
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class FormInputGroup < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :custom_form

  # ABSTRACT METHODS

  def self.valid_inputs
    raise NotImplementedError
  end

  # VALIDATIONS

  validate :inputs_valid

  def inputs_valid
    if inputs.present? && !is_subset(inputs, self.class.valid_inputs)
      errors.add :inputs,"must be one of: #{self.class.valid_inputs}.join(', ')"
    end
  end

  validate :required_inputs_valid

  def required_inputs_valid
    if required.present? && inputs.present? && !is_subset(required, inputs)
      errors.add(:required, "must be one of: #{inputs.join(", ")}")
    end
  end

  # ACCESSORS

  def sorted_inputs
    self.class.valid_inputs & inputs
  end

  # HELPERS

  private

  def is_subset arr1, arr2
    (arr1 - arr2).empty?
  end
end
