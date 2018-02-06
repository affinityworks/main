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
    :phone_input_group,
    :address_input_group,
  ]

  INPUT_GROUPS = [:person_input_group] + NESTED_INPUT_GROUPS

  # ASSOCIATIONS

  belongs_to :form
  accepts_nested_attributes_for :form
  delegate :description, :title, :name, :call_to_action, :submit_text, to: :form

  belongs_to :group

  INPUT_GROUPS.each do |input_group|
    has_one input_group,
            foreign_key: 'custom_form_id',
            class_name: input_group.to_s.camelize,
            dependent: :destroy
    accepts_nested_attributes_for input_group
  end

  # VALIDATIONS

  validates_presence_of :type

  # ACCESSORS

  def nested_input_groups
    NESTED_INPUT_GROUPS.map { |a| send(a) }
  end
end
