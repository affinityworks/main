class SubgroupsController < ApplicationController

  before_action :set_group

  # GET groups/:group_id/subgroups/new
  def new
    @subgroup = Group.new
    @subgroup.build_location
  end

  # POST groups/:group_id/subgroups
  def create
    @group.create_subgroup(subgroup_params)
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
end
