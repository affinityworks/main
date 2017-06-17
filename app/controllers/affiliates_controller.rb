class AffiliatesController < ApplicationController
  before_action :authenticate_person!

  def index
    group = current_person.groups.find(params[:group_id])
    affiliates = group.affiliates.includes(:creator).page(params[:page])

    affiliates = affiliates.tagged_with(params[:tag]) if params[:tag]

    if sort_param && direction_param
      sort = sort_param == 'owner' ? 'people.given_name' : sort_param

      affiliates = affiliates.order("#{sort} #{direction_param}")
    end

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

  private

  def sort_param
    @sort_param ||= ['name', 'owner'].include?(params[:sort]) && params[:sort] || nil
  end
end
