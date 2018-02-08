require_relative '../test_helper'

class SignupFormTest < ActiveSupport::TestCase

  let(:signup_form){ signup_forms(:one) }
  let(:group){ groups(:one) }

  specify "inheritance" do
    signup_form.must_be_kind_of CustomForm
    signup_form.must_be_instance_of SignupForm
    signup_form.type.must_equal 'SignupForm'
  end

  describe "validations" do

    let(:signup_form) { SignupForm.new }

    it "requries a group id" do
      signup_form.wont have_valid(:group_id).when(nil)
      signup_form.must have_valid(:group_id).when(1)
    end
  end

  describe "factories" do

    it "creates a default form for a group" do
      f = SignupForm.for(group)

      f.group.must_equal(group)

      f.name.must_equal "#{group.name}_default_signup_form"
      f.title.must_equal group.name
      f.description.must_equal group.description
      f.call_to_action.must_equal "get involved"

      f.person_input_group.inputs.must_equal(
        %w[given_name family_name]
      )
      f.email_input_group.inputs.must_equal(
        %w[address]
      )
      f.address_input_group.inputs.must_equal(
        %w[postal_code]
      )
      f.phone_input_group.inputs.must_equal []
    end
  end
end
