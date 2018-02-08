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
  # VALIDATIONS
  validates_presence_of :group_id

  def self.for(group)
    SignupForm.create!(
      group: group,
      form: Form.new(
        name: "#{group.name}_default_signup_form",
        title: "#{group.name}",
        description: group.description || "<div></div>",
        call_to_action: "get involved"
      ),
      person_input_group: PersonInputGroup.new(
        inputs: %w[given_name family_name]
      ),
      email_input_group: EmailInputGroup.new(
        inputs: %w[address]
      ),
      address_input_group: AddressInputGroup.new(
        inputs: %w[postal_code]
      ),
      phone_input_group: PhoneInputGroup.new
    )
  end
end
