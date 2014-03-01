class PlayersController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html

  def show
    @player = Player.find(params[:id])
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
    @player = @team.players.build(params[:player])
    respond_with(@player)
  end

  def create

    if params[:player]['team_id']
      @team = Team.find_by_slug( params[:player]['team_id'] )
      @player = @team.players.build(params[:player])
    else
      @player = Player.new(params[:player])
    end

    if @player.save and @player.errors.empty?
      flash[:notice] = "Player #{@player.first_name} #{@player.last_name} has been created "
      if @team
        #redirect_to @team
        redirect_to @player, :action => :show
      else
        redirect_to @player, :action => :show
      end
    else
      render :new
    end

  end

end
