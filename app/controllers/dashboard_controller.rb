class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @teams = current_user.admin? ? Team.all : current_user.managed_teams
    @players = current_user.players
  end

end
