class GroupTagsController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access

  protect_from_forgery except: [:create] #TODO: Add the csrf token in react.

  def create
    group = Group.find(params[:group_id])

    group.tag_list.add(params[:tag_name])
    group.save

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::TagsRepresenter.new(group.tags.last).to_json
      end
    end
  end
end
