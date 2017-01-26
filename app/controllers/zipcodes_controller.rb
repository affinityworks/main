class ZipcodesController < ApplicationController
  # GET /zipcodes/97214
  # GET /zipcodes/97214.json
  def show
    @zipcode = Zipcode.find_by zipcode: params[:id]
  end
end
