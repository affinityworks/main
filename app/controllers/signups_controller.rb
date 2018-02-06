class SignupsController < ApplicationController

  before_action :set_group, only: [:create]
  before_action :set_form, only: [:create]

  # POST /groups/:group_id/signup_forms/:signup_form_id/signup/

  def create
    # TODO move all persistence logic to Group.create_member_from_signup
    @member = @group.members.new(person_params)
    if @member.save # if @member.create_from_signup(person_params)
      @group.memberships.create(:person => @member, :role => 'member')
      # @group.signup.create(membership: membership, source: params.require(signup_form_id))
      redirect_to group_member_path(@group, @member), notice: "You joined #{@group.name}"
    else
      raise Exception.new(@member.errors.full_messages)
    end
  # rescue Exception => e
  #   binding.pry
  end

  private

  def set_group
    @group = Group.find(params.require(:group_id).to_i)
  end

  def set_form
    @form = SignupForm.find(params.require(:signup_form_id).to_i)
  end

  def person_params
    params.require(:person).permit(
      # TODO: (@aguestuser|06-Feb-2018)
      # permit ethnicities, languages, custom (see MembersController)
      PersonInputGroup::VALID_INPUTS +
      [phone_numbers_attributes: PhoneInputGroup::VALID_INPUTS,
      email_addresses_attributes: EmailInputGroup::VALID_INPUTS,
      personal_addresses_attributes: AddressInputGroup::VALID_INPUTS]
    )
  end

  def email_addresses_attributes_params
    [:primary,
     :address_type,
     :address]
  end

  def personal_addresses_attributes_params
    [:address_type,
     :primary,
     :address_lines,
     :locality,
     :region,
     :postal_code,
     :country,
     :occupation,
     :venue]
  end
end
