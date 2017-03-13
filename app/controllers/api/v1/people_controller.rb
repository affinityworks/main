class Api::V1::PeopleController < ApplicationController
  respond_to :json

  before_action :authenticate_api_user_from_token!
  before_action :authenticate_api_user!

  def index
    respond_to do |format|
      format.json do
        render json: Api::Collections::PeopleRepresenter.new(people, request)
      end
    end
  end

  private

  def people
    Api::Collections::People.new(
      Person.includes(:email_addresses).page(params[:page]).per(params[:per_page])
    )
  end

  def authenticate_api_user_from_token!
    osdi_api_token = request.headers['HTTP_OSDI_API_TOKEN'] || params[:osdi_api_token]
    return false unless osdi_api_token.present?

    api_user = Api::User.first_by_osdi_api_token(osdi_api_token)
    if api_user
      sign_in api_user, store: false
    end
  end
end
