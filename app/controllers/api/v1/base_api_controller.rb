class Api::V1::BaseApiController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api_user_from_token!

  private

  def authenticate_api_user_from_token!
    osdi_api_token = request.headers['HTTP_OSDI_API_TOKEN'] || params[:osdi_api_token]

    unless osdi_api_token.present?
      return head :unauthorized
    end

    api_user = Api::User.first_by_osdi_api_token(osdi_api_token)
    if api_user
      sign_in api_user, store: false
    end
  end
end
