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

  attr_reader :required_set

  # ASSOCIATIONS

  belongs_to :custom_form

  # LIFE_CYCLE HOOKS

  before_validation :parse_sets
  after_initialize :parse_sets

  def parse_sets
    @valid_input_set = self.class.valid_inputs.to_set
    @input_set = self.inputs.to_set
    @required_set = self.required.to_set
  end

  # ABSTRACT METHODS

  # () -> Array<String>
  def self.valid_inputs
    raise NotImplementedError
  end

  # () -> Symbol
  def resource
    raise NotImplementedError
  end

  # VALIDATIONS

  validate :inputs_valid

  def inputs_valid
    if inputs.present? && !@input_set.subset?(@valid_input_set)
      errors.add :inputs,"must be one of: #{self.class.valid_inputs}.join(', ')"
    end
  end

  validate :required_inputs_valid

  def required_inputs_valid
    if required.present? && inputs.present? && !@required_set.subset?(@input_set)
      errors.add(:required, "must be one of: #{inputs.join(", ")}")
    end
  end

  # ACCESSORS

  def sorted_inputs
    self.class.valid_inputs & inputs
  end
end
