require_relative '../test_helper'

class FormInputGroupTest < ActiveSupport::TestCase

  class ::FakeInputGroup < FormInputGroup
    VALID_INPUTS = ['foo', 'bar', 'baz']
    def self.valid_inputs; VALID_INPUTS; end
  end

  class ::FakeCustomForm < CustomForm; end

  let(:input_group){ form_input_groups(:abstract) }

  specify "inheritance" do
    input_group.must_be_instance_of FakeInputGroup
    input_group.must_be_kind_of FormInputGroup
  end

  specify "associations" do
    input_group.custom_form.must_be_kind_of CustomForm
  end

  describe "attributes" do

    it "has an array of available inputs" do
      input_group.inputs.must_be_kind_of Array
    end

    it "has an array of required inputes" do
      input_group.required.must_be_kind_of Array
    end
  end

  describe "interface" do

    it "requires subclasses to implement .valid_inputs" do
      ->{ FormInputGroup.valid_inputs }.must_raise NotImplementedError
    end
  end

  describe "validation" do

    let(:input_group){ FakeInputGroup.new }

    it "ensures inputs are subset of VALID_INPUTS" do
      input_group.wont have_valid(:inputs).when(['not_an_input_name'])
      input_group.must have_valid(:inputs).when(FakeInputGroup::VALID_INPUTS)
    end

    it "ensures required inputs are subset of inputs" do
      input_group.inputs = ['foo', 'bar']

      input_group.must have_valid(:required).when(['foo'])
      input_group.wont have_valid(:required).when(['baz'])
    end
  end

  describe "accessors" do

    it "provides a sorted list of inputs" do
      input_group.inputs = FakeInputGroup::VALID_INPUTS.dup.reverse
      input_group.sorted_inputs.must_equal FakeInputGroup::VALID_INPUTS
    end
  end
end
