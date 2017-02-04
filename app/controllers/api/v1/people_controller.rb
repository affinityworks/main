class Api::V1::PeopleController < ApplicationController
  respond_to :json

  before_action :authenticate_person_from_token!
  before_action :authenticate_person!

  def index
    respond_to do |format|
      format.json { @people = Person.all }
    end
  end

  private

  def authenticate_person_from_token!
    auth_token = request.headers[:auth_token].presence
    person       = auth_token && Person.where(authentication_token: auth_token.to_s).first

    if person
      sign_in person, store: false
    end
  end
end
