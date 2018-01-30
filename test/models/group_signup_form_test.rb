require_relative '../test_helper'

class GroupSignupFormTest < ActiveSupport::TestCase

  let(:signup_form){ group_signup_forms(:one) }

  specify "associations" do
    signup_form.group.must_be_instance_of Group
    signup_form.form.must_be_instance_of Form
  end

  describe "validations" do

    let(:signup_form) { GroupSignupForm.new }

    it "validates presence of required fields" do
      [:group_id, :inputs].each{ |attr| signup_form.wont have_valid(attr).when(nil) }
    end

    it "validates inputs are subset of `Person` fields" do
      signup_form.wont have_valid(:inputs).when(['foobar'])
      signup_form.must have_valid(:inputs).when(GroupSignupForm::VALID_INPUTS)
    end

    it "validates required inputs are subset of inputs" do
      signup_form.inputs = ['given_name', 'email_address', 'phone_number']

      signup_form.must have_valid(:required_inputs).when(['given_name'])
      signup_form.wont have_valid(:required_inputs).when(['postal_code'])
    end
  end

  describe "accessors" do

    let(:all_inputs){ GroupSignupForm::VALID_INPUTS.dup }

    it "provides statically ordered inputs" do
      signup_form.inputs = all_inputs.reverse
      signup_form.ordered_inputs.must_equal GroupSignupForm::VALID_INPUTS
    end
  end

  describe "nested attributes" do

    let(:signup_form) { group_signup_forms(:one) }

    it "creates a nested form from attributes hash" do
      assert_difference 'Form.count', 1 do
        GroupSignupForm.create!(
          group: groups(:one),
          inputs: ['given_name'],
          required_inputs: ['given_name'],
          form_attributes: {
            title: "foo",
            description: "bar",
            call_to_action: "baz",
          }
        )
      end
    end

    it "creates a nested form from object" do
      assert_difference 'Form.count', 1 do
        GroupSignupForm.create!(
          group: groups(:one),
          inputs: ['given_name'],
          required_inputs: ['given_name'],
          form: Form.create!(
            title: "foo",
            description: "bar",
            call_to_action: "baz",
          )
        )
      end
    end

    it "delegates to form attribute accessors" do
      [:description, :title, :name, :call_to_action].each do |method|
        signup_form.send(method).must_equal signup_form.form.send(method)
      end
    end

    it "validates nested form attributes" do
      signup_form.form.stub :valid?, false do
        signup_form.form.errors.stub :each, [] do
          signup_form.wont_be :valid?
        end
      end
    end

    it "displays error messages for nested form attributes" do
      signup_form.form.description = "<//dev>invalid html<dev//>"
      signup_form.valid?

      signup_form.errors.first.
        must_equal [:"form.description","must be valid HTML with no JavaScript"]
    end
  end
end
