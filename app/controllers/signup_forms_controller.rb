class SignupFormsController < ApplicationController

  before_action :set_form, only: :show
  before_action :set_group, only: :show
  before_action :set_member, only: :show

  # GET groups/:group_id/signup_forms/:id
  def show;end

  private

  def set_form
    @form = SignupForm.find(params.require(:id).to_i)
  end

  def set_group
    @group = @form.group
  end

  def set_member
    @member = Person.build_for_signup(@form)
  end
end
