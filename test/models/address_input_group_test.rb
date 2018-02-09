require_relative '../test_helper'

class AddressInputGroupTest < ActiveSupport::TestCase

  class ::FakeCustomForm < CustomForm
  end

  let(:address_input_group){ form_input_groups(:address) }

  specify "inheritance" do
    address_input_group.must_be_instance_of AddressInputGroup
    address_input_group.must_be_kind_of FormInputGroup
  end

  describe "interface" do

    it "provides VALID_INPUTS" do
      AddressInputGroup::VALID_INPUTS.wont_be_empty
    end

    it "provides RESOURCE" do
      AddressInputGroup::RESOURCE.wont_be_nil
    end

    it "provides ALIASES" do
      AddressInputGroup::ALIASES.wont_be_empty
    end

    it "provides a message for accessing its nested resoruces" do
      address_input_group.resource.must_equal :personal_addresses
    end

    it "provides aliases for field labels" do
      AddressInputGroup.label_for('primary').must_equal('Primary')
      AddressInputGroup.label_for('address_lines').must_equal('Address')
      AddressInputGroup.label_for('locality').must_equal('City')
      AddressInputGroup.label_for('region').must_equal('State')
    end
  end
end
