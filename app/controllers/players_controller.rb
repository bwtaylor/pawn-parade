class PlayersController < ApplicationController

  respond_to :html

  def show
    @player = Player.find(params[:id])
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

    raise "NO #{params[:player]['team_id']} " unless @player.team.slug == 'blattm'

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
