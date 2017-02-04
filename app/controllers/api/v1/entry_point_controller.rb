class Api::V1::EntryPointController < ApplicationController
  def show
    respond_to do |format|
      format.json
    end
  end
end
