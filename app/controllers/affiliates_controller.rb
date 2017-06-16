class AffiliatesController < ApplicationController
  before_action :authenticate_person!

  def index
    affiliates = current_person.groups.find(params[:group_id]).affiliates.page(params[:page])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          affiliates: JsonApi::GroupsRepresenter.for_collection.new(affiliates),
          total_pages: affiliates.total_pages,
          page: affiliates.current_page
        }.to_json
      end
    end
  end
end
