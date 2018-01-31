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
  belongs_to :form
  belongs_to :group
  has_many :input_groups,
           foreign_key: 'custom_form_id',
           class_name: 'FormInputGroup'

end
