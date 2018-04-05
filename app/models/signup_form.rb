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

  # LIFE CYCLE HOOKS
  after_create :save_browser_url
  def save_browser_url
    form.update(
      browser_url: Rails.application.routes.url_helpers.
        new_group_signup_form_signup_url(group_id, self.id)
    )
  end

  # FACTORIES
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
        inputs: %w[given_name family_name],
        required: %w[given_name family_name]
      ),
      email_input_group: EmailInputGroup.new(
        inputs: %w[address],
        required: %w[address]
      ),
      address_input_group: AddressInputGroup.new(
        inputs: %w[postal_code],
        required: %w[postal_code]
      ),
      phone_input_group: PhoneInputGroup.new(
        inputs: %w[number]
      )
    )
  end
end
