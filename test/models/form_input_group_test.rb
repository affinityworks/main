require_relative '../test_helper'

class FormInputGroupTest < ActiveSupport::TestCase

  class ::FakeInputGroup < FormInputGroup
  end

  class ::FakeCustomForm < CustomForm
  end

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
end
