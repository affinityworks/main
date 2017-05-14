class Api::V1::BaseApiController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token
  before_action :doorkeeper_authorize!
  # before_action :authenticate_api_user_from_token!
end
