require_relative '../test_helper'

class FormInputGroupTest < ActiveSupport::TestCase

  class ::AbstractInputGroup < FormInputGroup
  end

  class ::FakeInputGroup < FormInputGroup
    RESOURCE = :fakes
    VALID_INPUTS = ['foo', 'bar', 'baz']
    ALIASES = HashWithIndifferentAccess.new(
      foo: "proper foo",
      bar: "barrr"
    )
  end

  class ::AnotherFakeInputGroup < FormInputGroup
    RESOURCE = :more_fakes
    ALIASES = HashWithIndifferentAccess.new(baz_bam: 'bazinga!')
  end

  class ::FakeCustomForm < CustomForm; end

  let(:input_group){ form_input_groups(:abstract) }

  describe "inheritance" do
    specify { input_group.must_be_instance_of FakeInputGroup }
    specify { input_group.must_be_kind_of FormInputGroup }
  end

  describe "associations" do
    it "belongs to a custom form" do
      input_group.custom_form.must_be_kind_of CustomForm
    end
  end

  describe "attributes" do
    it "has an array of available inputs" do
      input_group.inputs.must_be_kind_of Array
    end

    it "has an array of required inputes" do
      input_group.required.must_be_kind_of Array
    end

    it "derrives a set of requried inputs" do
      input_group.required_set.must_equal input_group.required.to_set
    end
  end

  describe "interface" do
    it "has nil RESOURCE" do
      FormInputGroup::RESOURCE.must_be_nil
    end

    it "has empty VALID_INPUTS" do
      FormInputGroup::VALID_INPUTS.must_be_empty
    end

    it "has empty ALIASES" do
      FormInputGroup::ALIASES.must_be_empty
    end

    it "has an abstract #resource method" do
      ->{ FormInputGroup.new.resource }.must_raise NotImplementedError
    end

    describe "a concrete instance" do
      it "provides a message for accessing nested resources" do
        input_group.resource.must_equal :fakes
      end

      it "provides aliases for field labels" do
        FakeInputGroup.label_for('foo').must_equal "Proper Foo"
      end

      it "provides aliases for error emssages" do
        FakeInputGroup.error_for("hi there").must_equal "hi there"
        FakeInputGroup.error_for("hi foo bar").must_equal "hi proper foo barrr"
        FakeInputGroup.error_for("foo foo bar bar").must_equal "proper foo foo barrr bar"
      end

      it "replaces field names with aliases for many input groups" do
        FormInputGroup.error_for_many(
          [FakeInputGroup.new, AnotherFakeInputGroup.new],
          "Email addresses baz bam Foo",
        ).must_equal(
          "Bazinga! Foo"
        )
      end
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

    it "provides a label for a required field" do
      input_group.label_for(input_group.inputs.second)
        .must_equal "Barrr*"
    end

    it "provides a label for an optional field" do
      input_group.label_for(input_group.inputs.first)
        .must_equal "Proper Foo"
    end
  end

  describe "predicates" do

    it "reports that a field is required" do
      input_group.required?(input_group.inputs.second).must_equal true
    end

    it "reports that a field is not required" do
      input_group.required?(input_group.inputs.first).must_equal false
    end
  end
end
