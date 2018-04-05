# == Schema Information
#
# Table name: custom_forms
#
#  id       :integer          not null, primary key
#  type     :string           not null
#  form_id  :integer
#  group_id :integer
#

class CustomForm < ApplicationRecord

  # CONSTANTS

  NESTED_INPUT_GROUPS = [
    :email_input_group,
    :address_input_group,
    :phone_input_group,
  ]

  INPUT_GROUPS = [:person_input_group] + NESTED_INPUT_GROUPS

  # ASSOCIATIONS

  belongs_to :form
  accepts_nested_attributes_for :form
  delegate :browser_url,
           :call_to_action,
           :name,
           :submit_text,
           :title,
           :description,
           to: :form

  belongs_to :group

  INPUT_GROUPS.each do |input_group|
    has_one input_group,
            foreign_key: 'custom_form_id',
            class_name: input_group.to_s.camelize,
            dependent: :destroy
    accepts_nested_attributes_for input_group
  end

  # LIFE CYCLE HOOKS

  before_create :build_empty_nests

  def build_empty_nests
    NESTED_INPUT_GROUPS.each do |input_group|
      self.send("build_#{input_group}".to_sym) unless send(input_group).present?
    end
  end

  # VALIDATIONS

  validates_presence_of :type

  # ACCESSORS

  # Array<Symbol>(implicit) -> Array<FormInputGroup>
  def input_groups
    INPUT_GROUPS.map { |msg| send(msg) }
  end

  # Array<Symbol>(implicit) -> Array<FormInputGroup>
  def nested_input_groups
    NESTED_INPUT_GROUPS.map { |msg| send(msg) }
  end

  # Person -> Array<EmailAddress|PhoneNumber|Address>
  def nested_resources_for(person)
    nested_input_groups.map { |input_group| person.send(input_group.resource) }
  end
end
