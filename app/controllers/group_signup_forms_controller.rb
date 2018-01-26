class GroupSignupFormsController < ApplicationController

  before_action :set_group, only: :show
  before_action :set_signup_form, only: :show

  # GET groups/:group_id/signup_forms/:id
  def show;end

  private

  def set_group
    @group = Group.find(params.require(:group_id).to_i)
  end

  def set_signup_form
    @signup_form = GroupSignupForm.find(params.require(:id).to_i)
  end

end
