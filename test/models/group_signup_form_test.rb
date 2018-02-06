require_relative '../test_helper'

class SignupFormTest < ActiveSupport::TestCase

  let(:signup_form){ group_signup_forms(:one) }

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
end
