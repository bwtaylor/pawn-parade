class TournamentsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create, :update, :group_show, :guardian_show]
  before_filter :authorize_admin, :only => [:new, :create, :edit, :update, :index]

  respond_to :html

  def show
    @tournament = Tournament.find_by_slug(params[:id])
    asciidoc = @tournament.description_asciidoc
    @description = asciidoc.nil? ? @tournament.short_description : ::Asciidoctor.render(asciidoc)
  end

  def new
    @tournament = Tournament.new
    respond_with(@tournament)
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    if @tournament.save and @tournament.errors.empty?
      flash[:notice] = "Tournament #{@tournament.name} has been created with slug #{@tournament.slug}"
      redirect_to @tournament
    else
      render :new
    end
  end

  def edit
    @tournament = Tournament.find_by_slug(params[:id])
  end

  def update
    @tournament = Tournament.find_by_slug(params[:id])
    @tournament.update_attributes(params[:tournament])
    if @tournament.save and @tournament.errors.empty?
      flash[:notice] = "Tournament #{@tournament.name} [#{@tournament.slug}] has been updated "
      redirect_to tournaments_path, :action => :show
    else
      render :edit
    end
  end

  def index
    @upcoming = Tournament.upcoming
    @past = Tournament.past
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
    @registrations.select!{|r| ! %w(duplicate spam withdraw).include? r.status }
    @player_registrations = Hash.new
    @registrations.each {|r| @player_registrations[r.player]=r}
  end

  def uscf
    @tournament = Tournament.find_by_slug(params[:id])
    @registrations_needing_uscf = Registration.find_all_by_tournament_id_and_status(@tournament.id,'uscf id needed')
    @registrations_needing_uscf += Registration.find_all_by_tournament_id_and_status(@tournament.id,'uscf membership expired')
    @registrations_needing_uscf.sort_by!{|r| r.grade }
    respond_to do |format|
      format.tsv
    end
  end
end
