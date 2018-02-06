# == Schema Information
#
# Table name: custom_forms
#
#  id       :integer          not null, primary key
#  type     :string           not null
#  form_id  :integer
#  group_id :integer
#

class SignupForm < CustomForm
  # VAlIDATIONS
  validates_presence_of :group_id
end
