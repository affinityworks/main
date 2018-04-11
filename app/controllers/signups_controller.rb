class SignupsController < ApplicationController

  before_action :set_form, only: %i[new create]
  before_action :set_group, only: %i[new create]
  before_action :set_member, only: %i[new]

  # GET /groups/:group_id/signup_forms/:signup_form_id/new
  def new; end

  # POST /groups/:group_id/signup_forms/:signup_form_id/signup
  def create
    @member = Person.create_from_signup(@form, @group, person_params)
    if @member.errors.any?
      @member.build_signup_resources_for(@form)
      render :new
    else
      Signups::AfterCreate.call(member: @member, group: @group)
      redirect_to group_member_path(@group, @member),
                  notice: "You joined #{@group.name}"
    end
  end

  private

  def set_form
    @form = SignupForm
              .includes(:group)
              .find(params.require(:signup_form_id).to_i)
  end

  def set_group
    @group = @form.group
  end

  def set_member
    @member = Person.build_for_signup(@form)
  end

  def person_params
    params.require(:person).permit(
      # TODO: (@aguestuser|06-Feb-2018)
      # permit ethnicities, languages, custom (see MembersController)
      PersonInputGroup::VALID_INPUTS +
      [phone_numbers_attributes: PhoneInputGroup::VALID_INPUTS,
       email_addresses_attributes: EmailInputGroup::VALID_INPUTS,
       personal_addresses_attributes: AddressInputGroup::VALID_INPUTS]
    ).tap{ |p| arrayify_address_lines(p) }
  end

  def arrayify_address_lines(p)
    p.dig(:personal_addresses_attributes, '0').tap do |h|
      h&.merge!(address_lines: [h.fetch(:address_lines, nil)])
    end
  end

end
