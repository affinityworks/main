require_relative '../test_helper'

class EmailInputGroupTest < ActiveSupport::TestCase

  class ::FakeCustomForm < CustomForm
  end

  let(:email_input_group){ form_input_groups(:email) }

  specify "inheritance" do
    email_input_group.must_be_instance_of EmailInputGroup
    email_input_group.must_be_kind_of FormInputGroup
  end

  describe "interface" do

    it "provides VALID_INPUTS" do
      EmailInputGroup::VALID_INPUTS.wont_be_empty
    end

    it "provides RESOURCE" do
      EmailInputGroup::RESOURCE.wont_be_nil
    end

    it "provides ALIASES" do
      EmailInputGroup::ALIASES.wont_be_nil
    end


    it "provides a message for accessing its nested resources" do
      email_input_group.resource.must_equal :email_addresses
    end

    it "provides aliases for field labels" do
      EmailInputGroup.label_for('primary').must_equal 'Primary'
      EmailInputGroup.label_for('address_type').must_equal 'Email Address Type'
      EmailInputGroup.label_for('address').must_equal 'Email Address'
    end
  end
end
