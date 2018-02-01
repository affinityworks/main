require_relative '../test_helper'

class GroupSignupFormTest < ActiveSupport::TestCase

  let(:signup_form){ group_signup_forms(:one) }

  specify "inheritance" do
    signup_form.must_be_kind_of CustomForm
    signup_form.must_be_instance_of GroupSignupForm
    signup_form.type.must_equal 'GroupSignupForm'
  end

  describe "validations" do

    let(:signup_form) { GroupSignupForm.new }

    it "requries a group id" do
      signup_form.wont have_valid(:group_id).when(nil)
      signup_form.must have_valid(:group_id).when(1)
    end
  end
end
