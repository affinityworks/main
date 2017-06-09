class EventTagsController < ApplicationController
  before_action :authenticate_person!

  protect_from_forgery except: [:create] #TODO: Add the csrf token in react.

  def create
    event = Event.find(params[:event_id])

    event.tag_list.add(params[:tag_name])
    event.save

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::TagsRepresenter.new(event.tags.last).to_json
      end
    end
  end

  def destroy
    event = Event.find(params[:event_id])
    tag = event.tags.find(params[:id])

    tag.destroy
    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end
end
