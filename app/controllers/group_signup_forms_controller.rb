class GroupSignupFormsController < ApplicationController

  before_action :set_form, only: :show
  before_action :set_group, only: :show
  before_action :set_member, only: :show

  # GET groups/:group_id/signup_forms/:id
  def show;end

  private

  def set_form
    @form = GroupSignupForm.find(params.require(:id).to_i)
  end

  def set_group
    @group = @form.group
  end

  def set_member
    @member = Person.new
    @form.nested_input_groups.each do |input_group|
      @member.send(input_group.resource).build
    end
    # TODO: accomplish the building above with:
    # @member = Person.from_signup @form
  end
end
