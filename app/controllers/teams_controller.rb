require 'nokogiri'
require 'open-uri'

class TeamsController < ApplicationController

  before_filter :authenticate_user!

  def team_by_slug
    @team = Team.find_by_slug(params[:id])
  end

  def upcoming_tournaments
    today = Time.now.beginning_of_day
    @upcoming_tournaments = Tournament.where("registration = 'on' AND event_date >= :today", today: today).order(:event_date)
  end

  # GET /teams
  # GET /teams.json
  def index
    if current_user.admin?
      @teams = Team.all
    else
      #User.where(:username => "Paul").includes(:domains).where("domains.name" => "paul-domain").limit(1)
      @teams = current_user.managed_teams #Team.includes(:managers).where('users.email' => current_user.email)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    team_by_slug
    upcoming_tournaments

    @player = Player.new unless @player

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @team }
    end
  end

  def extract_player(hit)
    player = Player.new
    player.uscf_id = hit[0].content.strip[0,8]
    player.uscf_rating_reg = hit[1].content
    player.state = hit[4].content
    if hit[5].content.to_s.start_with?('Non-Member')
      player.uscf_status = 'JTP'
    else
      player.uscf_expires = Date.strptime hit[5].content, '%Y-%m-%d'      #'2014-03-31'
      player.uscf_status = player.uscf_expires <= Date.today ? 'EXPIRED' : 'MEMBER'
    end
    names = hit[6].content.split(/, /)
    player.last_name = names[0] #unless self.last_name
    player.first_name = names[1]
    player
  end

  def search
    team_by_slug
    upcoming_tournaments
    state = @team.state.nil? ? 'ANY' : @team.state
    flash[:notice] = "USCF Searches are better for teams with a value for State" if state == 'ANY'
    uri =  "http://www.uschess.org/datapage/player-search.php?"+
           "name=#{params[:uscf_search]}&state=#{state}&rating=R&mode=Find"
    player_lookup_uri =  URI::encode(uri)
    doc = Nokogiri::HTML(open(player_lookup_uri));
    raw_hits = doc.css('table.blog table tr')
    hit_cnt = raw_hits[0].css('td')[0].content.split(': ')[1].to_i
    hits = raw_hits[2..1+hit_cnt]
    @search_hits = hits.map {|hit| extract_player(hit.css('td'))}
    render :action => :show
  end

  def create_player
    team_by_slug
    upcoming_tournaments
    @player = @team.players.build(params[:player])
    @player.school = @team.name
    @player.state = @team.state
    @player.city = @team.city
    @player.county = @team.county
    if params[:uscf_id]
      @player.uscf_id = params[:uscf_id]
      @player.pull_uscf
      p = @player
      if @player.save and @player.errors.empty?
        @player = Player.new
        redirect_to @team
      else
        render 'players/new'
      end
    else
      render 'players/new'
    end
  end

  # GET /teams/new
  # GET /teams/new.json
  def new
    @team = Team.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @team }
    end
  end

  # GET /teams/1/edit
  def edit
    team_by_slug
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(params[:team])

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render json: @team, status: :created, location: @team }
      else
        format.html { render action: "new" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.json
  def update
    team_by_slug

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    team_by_slug
    @team.destroy

    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end
end
