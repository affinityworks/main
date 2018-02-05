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

  NESTED_INPUT_GROUP_ASSOCIATIONS = [
    :email_input_group,
    :phone_input_group,
    :address_input_group,
  ]

  INPUT_GROUP_ASSOCIATIONS = [
    :person_input_group
  ] + NESTED_INPUT_GROUP_ASSOCIATIONS

  # ASSOCIATIONS

  belongs_to :form
  accepts_nested_attributes_for :form
  delegate :description, :title, :name, :call_to_action, :submit_text, to: :form

  belongs_to :group

  INPUT_GROUP_ASSOCIATIONS.each do |association|
    has_one association,
            foreign_key: 'custom_form_id',
            class_name: association.to_s.camelize,
            dependent: :destroy
    accepts_nested_attributes_for association
  end

  # VALIDATIONS

  validates_presence_of :type

  # ACCESSORS

  def nested_input_groups
    NESTED_INPUT_GROUP_ASSOCIATIONS.map { |a| send(a) }
  end
end
