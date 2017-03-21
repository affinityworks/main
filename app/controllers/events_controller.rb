class EventsController < ApplicationController
  before_action :authenticate_person!
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.json do
        render json: JsonApi::EventsRepresenter.for_collection.new(@events).to_json
      end
    end
  end
end
