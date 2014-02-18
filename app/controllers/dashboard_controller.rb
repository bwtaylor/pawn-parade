class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @teams = current_user.managed_teams
  end
end
