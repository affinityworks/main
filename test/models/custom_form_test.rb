require_relative '../test_helper'

class CustomFormTest < ActiveSupport::TestCase

  class ::FakeInputGroup < FormInputGroup
  end

  class ::FakeCustomForm < CustomForm
  end

  let(:custom_form){ custom_forms(:abstract) }
  let(:form_attributes) do
    {
      name: 'foo',
      title: 'bar',
      description: 'baz',
      call_to_action: 'bam',
    }
  end

  def create_form
    FakeCustomForm.create!(
      form_attributes: form_attributes,
      person_input_group_attributes: { inputs: [] },
      phone_input_group_attributes: { inputs: [] },
      email_input_group_attributes: { inputs: [] },
      address_input_group_attributes: { inputs: [] }
    )
  end

  specify "inheritance" do
    custom_form.must_be_instance_of FakeCustomForm
    custom_form.must_be_kind_of CustomForm
  end

  describe "associations" do

    it "has a nested form and group" do
      custom_form.form.must_be_instance_of Form
      custom_form.group.must_be_instance_of Group
    end

    it "has nested form input groups" do
      custom_form.person_input_group.must_be_kind_of PersonInputGroup
      custom_form.email_input_group.must_be_kind_of EmailInputGroup
      custom_form.phone_input_group.must_be_kind_of PhoneInputGroup
      custom_form.address_input_group.must_be_kind_of AddressInputGroup
    end

    it "initializes builds empty input groups when none are provided" do
      f = FakeCustomForm.new(form_attributes: form_attributes)
      CustomForm::NESTED_INPUT_GROUPS.each { |ig| f.send(ig).must_be_nil }
      f.save
      CustomForm::NESTED_INPUT_GROUPS.each { |ig| f.send(ig).wont_be_nil }
    end

    it "destroys associatied input groups when destroyed" do
      decrement = CustomForm::INPUT_GROUPS.count * -1
      form = create_form

      assert_difference "FormInputGroup.count", decrement do
        form.destroy
      end
    end
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
        CustomForm::INPUT_GROUPS.each do |assn|
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
      [
        :browser_url,
        :call_to_action,
        :description,
        :name,
        :submit_text,
        :title,
      ].each do |method|
        custom_form.send(method).must_equal custom_form.form.send(method)
      end
    end

    it "provides a list of input groups for nested attributes" do
      custom_form.nested_input_groups
        .must_equal([custom_form.email_input_group,
                     custom_form.address_input_group,
                     custom_form.phone_input_group])
    end
  end
end
