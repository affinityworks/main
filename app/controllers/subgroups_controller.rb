class SubgroupsController < ApplicationController

  before_action :set_group

  # GET groups/:group_id/subgroups/new
  def new
    @subgroup = Group.build_group_with_organizer
  end

  # POST groups/:group_id/subgroups
  def create
    @subgroup, organizer = @group.create_subgroup_with_organizer(
      subgroup_attrs: subgroup_params,
      organizer_attrs: organizer_params
    )
    if @subgroup.valid?
      OrganizerMailer
        .new_subgroup_email(organizer, @subgroup, SignupForm.for(@subgroup))
        .deliver_later

      CreateGoogleGroup.call(organizer: organizer, group: @subgroup) if FeatureToggle.on?(:google_groups, @subgroup)

      sign_in_and_redirect(organizer)
    else
      render :new
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def subgroup_params
    params
      .require(:group)
      .permit(:name, :description, :summary, location_attributes: [:postal_code])
  end

  def organizer_params
    params
      .require(:group)
      .permit(
        organizer_attributes: [
          :given_name,
          :family_name,
          :password,
          phone_numbers_attributes: [:number],
          email_addresses_attributes: [:address],
          personal_addresses_attributes: [:postal_code]
        ]
      )
      .fetch('organizer_attributes')
      .tap { |organizer_attrs| format_contact_info(organizer_attrs) }
  end

  def format_contact_info(organizer_attrs)
    [
      'phone_numbers_attributes',
      'email_addresses_attributes',
      'personal_addresses_attributes'
    ].each do |attrs|
      organizer_attrs.merge!(
        attrs => [organizer_attrs.fetch(attrs).merge(primary: true)]
      )
    end
  end
end
