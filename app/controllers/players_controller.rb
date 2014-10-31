class PlayersController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html

  def show
    @player = Player.find(params[:id])
    @registrations = @player.registrations
    @tournaments = Tournament.where("registration = 'on' AND event_date >= :today", today: Time.now.beginning_of_day)
    @tournaments -= @registrations.map {|r| r.tournament}
    @registration = Registration.new(params[:registration])
    @tournament = Tournament.find(@registration.tournament_id) unless @registration.tournament_id.nil?
  end


  def register
    @player = Player.find(params[:id])
    @registration = Registration.new(params[:registration])
    @tournament = Tournament.find(params[:registration][:tournament_id])
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @player = Player.find(params[:id])
    @player.update_attributes(params[:player])
    if @player.save and @player.errors.empty?
      flash[:notice] = "Player #{@player.first_name} #{@player.last_name} has been updated "
      if @player.team.nil?
        redirect_to @player, :action => :show
      else
        redirect_to @player.team, :action => :show
      end
    else
      render :edit
    end
  end

  def new
    @team = Team.find_by_slug(params[:team_id])
    if @team.nil?
      @player = Player.new
    else
      @player = @team.players.build(params[:player])
    end
    respond_with(@player)
  end
  
  def freshen_uscf
    @player = Player.find(params[:id])
    @player.uscf
    @player.save!
    redirect_to action: :show, id: params[:id]
  end

  def create

    if params[:creation_type].eql?('guardian')
      @player = Player.new(params[:player])
      @team = Team.find_by_slug( params[:player][:team_id] )
      if @team
        @player.team_id = @team.id
        @player.school = @team.name
      end
    else
      @team = Team.find_by_slug( params[:add_to_team] )
      @player = @team.players.build(params[:player])
    end

    if @player.save and @player.errors.empty?
      flash[:notice] = "Player #{@player.first_name} #{@player.last_name} has been created "
      if params[:creation_type].eql?('team')
        redirect_to @team
      else
        @player.add_guardians(current_user.email)
        redirect_to @player, :action => :show
      end
    else
      render :new
    end

  end

end
