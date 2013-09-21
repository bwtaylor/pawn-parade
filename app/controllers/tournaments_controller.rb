class TournamentsController < ApplicationController
  def show
    @tournament = Tournament.find_by_slug(params[:id])
  end
end
