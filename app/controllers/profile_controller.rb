class ProfileController < ApplicationController
  before_action :authenticate_person!

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::PeopleRepresenter.new(current_user).to_json
      end
    end
  end

  def groups
    @groups = current_user.groups.page(params[:page])
    respond_to do |format|
      format.html
      format.json do
        render json: {
          groups: JsonApi::GroupsRepresenter.for_collection.new(@groups),
          total_pages: @groups.total_pages,
          page: @groups.current_page
        }.to_json
      end
    end
  end
end
