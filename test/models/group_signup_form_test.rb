require 'test_helper'

# == Schema Information
#
# Table name: group_signup_forms
#
#  id              :integer          not null, primary key
#  group_id        :integer
#  person_fields   :string           default([]), is an Array
#  required_fields :string           default([]), is an Array
#  page_text       :string           not null
#  button_text     :string           not null
#  prompt_text     :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


class GroupSignupFormTest < ActiveSupport::TestCase

  describe "associations" do

    let(:signup_form){ group_signup_forms(:one) }

    it "belongs to a group" do
      signup_form.group.must_be_instance_of Group
    end
  end

  describe "validations" do

    let(:signup_form) { GroupSignupForm.new }

    it "validates presence of required fields" do
      [:admin_title,
       :button_text,
       :display_title,
       :group_id,
       :page_text,
       :person_fields,
       :prompt_text].each{|field| signup_form.wont have_valid(field).when(nil)}
    end

    it "validates `person_fields` are subset of `Person` fields" do
      signup_form.wont have_valid(:person_fields).when(['foobar'])
      signup_form.must have_valid(:person_fields).when(GroupSignupForm::VALID_PERSON_FIELDS)
    end

    it "validates `required_fields` are subset of `person_fields`" do
      signup_form.person_fields = ['given_name', 'email_address', 'phone_number']

      signup_form.must have_valid(:required_fields).when(['given_name'])
      signup_form.wont have_valid(:required_fields).when(['postal_code'])
    end

    it "validates that `page_text` is valid html" do
      signup_form.must have_valid(:page_text).when('<a href="foobar">Hi!</a>')
      signup_form.wont have_valid(:page_text).when('</div><div>')
    end

    it "does not allow javascript in the `page_text`" do
      signup_form.wont have_valid(:page_text).when('<script>alert("pwned!")</script>')
    end
  end
end
