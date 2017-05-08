class MembersController < ApplicationController
  before_action :authenticate_person!

  before_action :set_members

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          members: JsonApi::PeopleRepresenter.for_collection.new(@members),
          total_pages: @members.total_pages,
          page: @members.current_page
        }.to_json
      end
    end
  end

  private

  def set_members
    @members = current_group.members.page(params[:page])
  end
end
