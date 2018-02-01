require_relative '../test_helper'

class PersonInputGroupTest < ActiveSupport::TestCase

  class ::FakeCustomForm < CustomForm
  end

  let(:person_input_group){ form_input_groups(:person) }

  specify "inheritance" do
    person_input_group.must_be_instance_of PersonInputGroup
    person_input_group.must_be_kind_of FormInputGroup
  end

  describe "interface" do

    it "implements .valid_inputs" do
      PersonInputGroup.valid_inputs.must_equal PersonInputGroup::VALID_INPUTS
    end
  end
end
