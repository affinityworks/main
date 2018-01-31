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
  belongs_to :custom_form
end
