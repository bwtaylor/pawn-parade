class SectionsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @sections = @tournament.sections
    @registrations = @tournament.registrations
    @counts = Hash.new
    @sections.each do |section|
      @counts[section.name] = 0
    end
    ignored_statuses = ['duplicate', 'withdraw', 'spam', 'no show']
    @registrations.each do |registration|
      @counts[registration.section] += 1 unless ignored_statuses.include?(registration.status)
    end
  end

  def show
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @section = Section.find_by_slug(params[:id])
    @registrations = Registration.find_all_by_tournament_id_and_section(@tournament.id, @section.name)

    @players = @registrations.map {|r| r.player}.sort_by {|r| [r.last_name, r.first_name] }
    @player_registrations = Hash.new
    @registrations.each do |r|
      @player_registrations[r.player]=r
    end
  end

  def edit
  end

  def update
  end


end
