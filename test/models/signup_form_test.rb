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

  describe "lifecycle hooks" do
    it "saves `form.browser_url` after creation" do
      f= SignupForm.for(group)
      f.form
        .browser_url
        .must_equal "http://localhost:3000/groups/#{group.id}" +
                    "/signup_forms/#{f.id}/signups/new"
    end
  end

  describe "factories" do
    describe ".for" do
      let(:f){ SignupForm.for group }

      specify { f.group.must_equal(group) }
      specify { f.name.must_equal "#{group.name}_default_signup_form" }
      specify { f.title.must_equal group.name }
      specify { f.description.must_equal group.description }
      specify { f.call_to_action.must_equal "join our group" }

      it 'includes correct person fields' do
        f.person_input_group.inputs
          .must_equal %w[given_name family_name]
      end

      it 'requires correct person fields' do
        f.person_input_group.required
          .must_equal %w[given_name family_name]
      end

      it 'includes correct email fields' do
        f.email_input_group.inputs
          .must_equal %w[address]
      end

      it 'requires correct address fields' do
        f.address_input_group.required
          .must_equal %w[postal_code]
      end

      it 'includes correct phone fields' do
        f.phone_input_group.inputs
          .must_equal %w[number]
      end

      it 'requires no phone fields' do
        f.phone_input_group.required.must_be_empty
      end
    end
  end
end
