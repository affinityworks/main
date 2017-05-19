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

end
