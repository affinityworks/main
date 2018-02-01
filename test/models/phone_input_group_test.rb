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

    it "implements .valid_inputs" do
      PhoneInputGroup.valid_inputs.must_equal PhoneInputGroup::VALID_INPUTS
    end
  end
end
