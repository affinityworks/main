class DashboardController < ApplicationController
  before_action :authorize_group_access
end
