class TagsController < ApplicationController
  protect_from_forgery except: [:create]
  before_action :authorize_group_access

  TYPE_MAPPING = {
    'event' => Event,
    'membership' => Membership,
    'group' => Group
  }

  def create
    render_not_found and return unless resource

    resource.tag_list.add(params[:tag_name])
    resource.save

    respond_to do |format|
      format.json do
        render json: JsonApi::TagsRepresenter.new(resource.tags.last).to_json
      end
    end
  end

  def destroy
    render_not_found and return unless resource

    tag = resource.tags.find(params[:id])
    resource.tag_list.remove(tag.name)
    resource.save
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def resource
    model = TYPE_MAPPING[params[:resource_type]] or return
    @resource ||= model.find(params[:resource_id])
  end
end
