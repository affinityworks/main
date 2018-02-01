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
    custom_form.form.must_be_instance_of Form
    custom_form.group.must_be_instance_of Group
    custom_form.person_input_group.must_be_kind_of PersonInputGroup
    custom_form.email_input_group.must_be_kind_of EmailInputGroup
    custom_form.phone_input_group.must_be_kind_of PhoneInputGroup
    custom_form.address_input_group.must_be_kind_of AddressInputGroup
  end

  describe "validations" do

    let(:custom_form){ CustomForm.new }

    it "requires a subclass type" do
      custom_form.wont have_valid(:type).when(nil)
      custom_form.must have_valid(:type).when('FakeCustomForm')
    end
  end


  describe "nested attributes" do

    describe "for a form" do

      it "creates a form" do
        assert_difference "Form.count", 1 do
          FakeCustomForm.create!(
            form_attributes: {
              title: 'foo',
              description: 'bar',
              call_to_action: 'baz'
            }
          )
        end
      end

      it "will not validate if form invalid" do
        cf = FakeCustomForm.create(
          form_attributes: {
            title: 'foo',
            description: "<//dev>invalid html<dev//>",
            call_to_action: 'baz'
          }
        )
        cf.wont_be :valid?
        cf.errors.full_messages.first.must_match "Form description"
      end
    end

    describe "for input groups" do

      it "creates input groups" do
        CustomForm::INPUT_GROUP_ASSOCIATIONS.each do |assn|
          klass_name = assn.to_s.camelize
          attrs = "#{assn}_attributes".to_sym
          assert_difference "#{klass_name}.count", 1 do
            FakeCustomForm.create!(attrs => { inputs: [], required: [] })
          end
        end
      end

      it "will not validate if an input group is invalid" do
        cf = FakeCustomForm.create(
          person_input_group_attributes: {
            inputs: ['foobar']
          }
        )
        cf.wont_be :valid?
        cf.errors.full_messages.first.must_match "Person input group"
      end
    end
  end

  describe "accessors" do

    it "delegates to nested form accessors" do
      [:description, :title, :name, :call_to_action].each do |method|
        custom_form.send(method).must_equal custom_form.form.send(method)
      end
    end

    it "provides a list of sorted input groups" do
      custom_form.sorted_input_groups
        .must_equal([custom_form.person_input_group,
                     custom_form.email_input_group,
                     custom_form.phone_input_group,
                     custom_form.address_input_group])
    end
  end
end
