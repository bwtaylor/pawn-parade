class RegistrationsController < ApplicationController

  respond_to :html

  def new
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build
    respond_with(@registration)
  end

  def create
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build(params[:registration])
    if @registration.save
       flash[:notice] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
                        " in section #{@registration.section} of #{@tournament.name}"
      redirect_to @tournament, :action => :show
    else
      render :new
    end
  end

  def index
  end

  # MOVE THIS TO SOMEWHERE BETTER
  def lookup_uscf_id(uscf_id)
    #http://chess.stackexchange.com/questions/1295/is-there-a-uscf-api
    player_lookup_uri =  "http://www.uschess.org/msa/thin.php?#{uscf_id}"
  end

end
