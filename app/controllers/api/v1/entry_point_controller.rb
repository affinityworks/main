class Api::V1::EntryPointController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: Api::EntryPointRepresenter.new(Api::EntryPoint.new) }
    end
  end
end
