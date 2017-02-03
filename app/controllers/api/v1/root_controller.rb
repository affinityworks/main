class Api::V1::RootController < ApplicationController
  def show
    respond_to do |format|
      format.json
    end
  end
end
