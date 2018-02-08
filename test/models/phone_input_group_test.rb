require_relative '../test_helper'

class PhoneInputGroupTest < ActiveSupport::TestCase

  class ::FakeCustomForm < CustomForm
  end

  let(:phone_input_group){ form_input_groups(:phone) }

  specify "inheritance" do
    phone_input_group.must_be_instance_of PhoneInputGroup
    phone_input_group.must_be_kind_of FormInputGroup
  end

  describe "interface" do

    it "provides VALID_INPUTS" do
      PhoneInputGroup::VALID_INPUTS.wont_be_empty
    end

    it "provides RESOURCE" do
      PhoneInputGroup::RESOURCE.wont_be_nil
    end

    it "provides ALIASES" do
      PhoneInputGroup::ALIASES.wont_be_empty
    end

    it "provides a message for accessing its nested resoruces" do
      phone_input_group.resource.must_equal :phone_numbers
    end

    it "provides aliases for field labels" do
      PhoneInputGroup.label_for('primary').must_equal('Primary')
      PhoneInputGroup.label_for('number_type').must_equal('Phone Number Type')
      PhoneInputGroup.label_for('number').must_equal('Phone Number')
    end
  end
end
