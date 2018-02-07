require_relative "../test_helper"

class SignupForms < FeatureTest

  let(:form){ custom_forms(:group_signup) }
  before { visit "/groups/#{form.group.id}/signup_forms/#{form.id}" }

  describe "viewing form" do

    it "has a " do
      page.must_have_content form.title
    end

    it "has a description" do
      page.html.must_match form.description
    end

    it "has a call to action" do
      page.must_have_text form.call_to_action.titleize
    end

    it "has a submit button" do
      page.must_have_selector "input.submit"
    end

    it "has inputs for creating a member" do
      CustomForm::INPUT_GROUPS.each do |input_group|
        form.send(input_group).inputs.each do |input|
          selector = input_selector_for(form.send(input_group), input)
          page.find(selector)['placeholder'].must_equal input.titleize
        end
      end
    end
  end

  describe "submitting form" do
    let(:input_groups){ CustomForm::INPUT_GROUPS.map{ |ig| form.send(ig) } }
    let(:person_count){ Person.count }
    let(:membership_count){ Membership.count }
    let(:new_member){ Person.last }

    before do
      # because minitest won't allow `let!`
      person_count
      membership_count
    end

    describe "with no errors" do
      before do
        fill_out_form values_by_input(input_groups)
        click_button form.submit_text
      end

      it "creates a new person" do
        Person.count.must_equal person_count + 1
      end

      it "creates a new membership" do
        Membership.count.must_equal membership_count + 1
      end

      it "stores persons's contact info" do
        [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
          new_member.reload.send(msg).first.primary?.must_equal true
        end
      end
    end

    describe "with errors" do
      before do
        fill_out_form(
          person_email_addresses_attributes_0_address: 'invalid',
          person_phone_numbers_attributes_0_number: 'invalid'
        )
        click_button form.submit_text
      end

      # TODO (aguestuser|07-Feb-2018)
      # these error messages are T.R.A.S.H.

      it "shows an error for missing fields" do
        page.must_have_content "Family name can't be blank"
      end

      it "shows an error for invalid email address" do
        page.must_have_content
        "Email addresses address 'invalid' does not match" +
          "(?i-mx:\\A([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})\\z)"
      end

      it "shows an error for invalid phone number" do
        page.must_have_content
        "Phone numbers number Only numbers format are allowed"
      end
    end

    private

    def count_contact_infos
      EmailAddress.count + PersonalAddress.count + PhoneNumber.count
    end

  end

  private

  def input_selector_for(input_group, input)
    case input_group
    when PersonInputGroup
      "#person_#{input}"
    else
      "#person_#{input_group.resource}_attributes_0_#{input}"
    end
  end

  def values_by_input(input_groups)
    input_groups.reduce({}) do |acc, input_group|
      input_group.inputs.reduce(acc) do |_acc, input|
        _acc.merge(
          input_selector_for(input_group, input).gsub("#", "") =>
          value_for(input_group, input)
        )
      end
    end
  end

  def value_for(input_group, input)
    case input_group
    when PersonInputGroup
      people(:new_signup).send(input)
    else
      attr = people(:new_signup).send(input_group.resource).first.send(input)
      attr = attr.respond_to?(:join) ? attr.join(", ") : attr
      is_email_address?(input_group, input)? "fake@example.com" : attr
    end
  end

  def is_email_address?(input_group, input)
    input_group.is_a?(EmailInputGroup) && input == 'address'
  end
end
