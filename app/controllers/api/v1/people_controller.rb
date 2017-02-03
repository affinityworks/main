class Api::V1::PeopleController < ApplicationController
  respond_to :json

  def index
    respond_to do |format|
      format.json { @people = Person.all }
    end
  end
end
