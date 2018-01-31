require_relative '../test_helper'

class CustomFormTest < ActiveSupport::TestCase

  class ::FakeInputGroup < FormInputGroup
  end

  class ::FakeCustomForm < CustomForm
  end

  let(:custom_form){ custom_forms(:abstract) }

  specify "inheritance" do
    custom_form.must_be_instance_of FakeCustomForm
    custom_form.must_be_kind_of CustomForm
  end

  specify "associations" do
    custom_form.input_groups.first.must_be_kind_of FormInputGroup
    custom_form.form.must_be_instance_of Form
    custom_form.group.must_be_instance_of Group
  end

end
