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

    it "provides VALID_INPUTS" do
      PersonInputGroup::VALID_INPUTS.wont_be_empty
    end

    it "provides RESOURCE" do
      PersonInputGroup::RESOURCE.wont_be_nil
    end

    it "provides ALIASES" do
      PersonInputGroup::ALIASES.wont_be_nil
    end


    it "provides a message for accessing its nested resoruces" do
      person_input_group.resource.must_equal :person
    end

    it "provides aliases for field labels" do
      PersonInputGroup.label_for('birthdate').must_equal 'Birthdate'
      PersonInputGroup.label_for('given_name').must_equal 'First Name'
      PersonInputGroup.label_for('family_name').must_equal 'Last Name'
    end
  end
end
