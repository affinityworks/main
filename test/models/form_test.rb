require 'test_helper'

class FormTest < ActiveSupport::TestCase

  let(:form){ forms(:one) }

  specify "associations" do
    form.person.must_be_instance_of Person
    form.creator.must_be_instance_of Person
    form.submissions.first.must_be_instance_of Submission
  end

  describe "validations" do

    let(:form) { Form.new }

    it "validates presence of required fields" do
      no_defaults = Form::REQUIRED_ATTRIBUTES - Form::DEFAULTS_BY_ATTRIBUTE.keys
      no_defaults.each{ |attr| form.wont have_valid(attr).when(nil) }
    end

    it "validates description is valid html" do
      form.must have_valid(:description).when('foobar')
      form.must have_valid(:description).when('<a href="foobar">Hi!</a>')
      form.wont have_valid(:description).when('</div><div>')
    end

    it "does not allow javascript in the description" do
      form.wont have_valid(:description).when('<script>alert("pwned!")</script>')
    end
  end

  describe "attributes" do

    it "provides a default submit text if none is provided" do
      form.submit_text = nil
      form.save
      form.submit_text.must_equal "submit"
    end

    it "sets name to title if none is provided" do
      form.name = nil
      form.save
      form.name.must_equal form.title
    end
  end
end
