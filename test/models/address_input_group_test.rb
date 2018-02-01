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

    it "implements .valid_inputs" do
      AddressInputGroup.valid_inputs.must_equal AddressInputGroup::VALID_INPUTS
    end
  end
end
