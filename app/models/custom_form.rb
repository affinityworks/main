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

  INPUT_GROUP_ASSOCIATIONS = [
    :person_input_group,
    :email_input_group,
    :phone_input_group,
    :address_input_group,
  ]

  # ASSOCIATIONS

  belongs_to :form
  accepts_nested_attributes_for :form
  delegate :description, :title, :name, :call_to_action, to: :form

  belongs_to :group

  INPUT_GROUP_ASSOCIATIONS.each do |association|
    has_one association,
            foreign_key: 'custom_form_id',
            class_name: association.to_s.camelize
    accepts_nested_attributes_for association
  end

  # VALIDATIONS

  validates_presence_of :type

  # ACCESSORS

  def sorted_input_groups
    INPUT_GROUP_ASSOCIATIONS.map { |a| send(a) }
  end
end
