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

    it "implements .valid_inputs" do
      EmailInputGroup.valid_inputs.must_equal EmailInputGroup::VALID_INPUTS
    end
  end
end
