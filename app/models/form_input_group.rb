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

  # CONSTANTS

  INPUT_GROUP_CLASSNAMES = %w[
    EmailInputGroup
    PhoneInputGroup
    AddressInputGroup
    PersonInputGroup
  ]

  # subclasses should override these
  RESOURCE = nil
  VALID_INPUTS = []
  ALIASES = {}

  # ASSOCIATIONS

  belongs_to :custom_form

  # LIFE_CYCLE HOOKS

  before_validation :parse_sets
  after_initialize :parse_sets

  def parse_sets
    @valid_input_set = self.class::VALID_INPUTS.to_set
    @input_set = self.inputs.to_set
    @required_set = self.required.to_set
  end

  # CLASS METHODS

  def self.label_for(input)
    self::ALIASES.fetch(input, input).titleize
  end

  def self.error_for(msg)
    self::ALIASES.keys.reduce(msg) do |acc, aliased_str|
      acc.sub(
        aliased_str.gsub("_", " "),
        self::ALIASES.fetch(aliased_str)
      )
    end
  end

  def self.error_for_many(input_groups, msg)
    _msg = strip_resource_names(input_groups, msg)
    input_groups.reduce(_msg) do |acc, ig|
      ig.class.error_for(acc)
    end.lstrip.camelcase
  end

  def self.strip_resource_names(input_groups, str)
    FormInputGroup::INPUT_GROUP_CLASSNAMES
      .reduce(str.camelcase(:lower)) do |acc, klass_name|
      acc.sub(
        klass_name.constantize::RESOURCE.to_s.gsub("_", " "),
        ""
      )
    end
  end

  # ABSTRACT METHODS

  # () -> Symbol
  def resource
    raise NotImplementedError unless self.class::RESOURCE
    self.class::RESOURCE
  end

  # VALIDATIONS

  validate :inputs_valid

  def inputs_valid
    if inputs.present? && !@input_set.subset?(@valid_input_set)
      errors.add :inputs,"must be one of: #{@valid_input_set}.join(', ')"
    end
  end

  validate :required_inputs_valid

  def required_inputs_valid
    if required.present? && inputs.present? && !@required_set.subset?(@input_set)
      errors.add(:required, "must be one of: #{inputs.join(", ")}")
    end
  end

  # INSTANCE METHODS

  def sorted_inputs
    self.class::VALID_INPUTS & inputs
  end


end
