class AffiliatesController < ApplicationController
  before_action :authenticate_person!

  before_action :authorize_group_access
end
