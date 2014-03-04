class TournamentsController < ApplicationController

  def show
    @tournament = Tournament.find_by_slug(params[:id])
    asciidoc = @tournament.description_asciidoc
    @description = asciidoc.nil? ? @tournament.short_description : ::Asciidoctor.render(asciidoc)
  end

  def team_show
    @team = Team.find_by_slug(params[:team_id])
    @players = @team.players
    group_show(@players)
  end

  def guardian_show
    @players = current_user.players
    group_show(@players)
  end


  def group_show(players)
    @tournament = Tournament.find_by_slug(params[:id])
    @registrations = Registration.where(player_id: players.map{|p| p.id}).where(tournament_id: @tournament.id)
    @player_registrations = Hash.new
    @registrations.each {|r| @player_registrations[r.player]=r}
  end
end
