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

    associate_player(@registration)

    if @registration.save
      if @registration.status == 'request'
       flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
                            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status == 'waiting list'
        flash[:registered] = "SECTION FULL!! #{@registration.first_name} #{@registration.last_name} is on the waiting list " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      end
      redirect_to @tournament, :action => :show
    else
      render :new
    end
  end

  def index
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registrations = @tournament.registrations
  end

  # MOVE THIS TO SOMEWHERE BETTER
  def lookup_uscf_id(uscf_id)
    #http://chess.stackexchange.com/questions/1295/is-there-a-uscf-api
    player_lookup_uri =  "http://www.uschess.org/msa/thin.php?#{uscf_id}"
  end

  def associate_player(registration)
    r = registration
    player = Player.find_by_uscf_id(r.uscf_member_id) unless r.uscf_member_id.nil?
    player = Player.find_by_first_name_and_last_name_and_grade(r.first_name, r.last_name, r.grade) if player.nil?
    player = Player.create(
                 :first_name => r.first_name,
                 :last_name => r.last_name,
                 :uscf_id => r.uscf_member_id,
                 :grade => r.grade,
                 :date_of_birth => r.date_of_birth,
                 :gender => r.gender,
                 :address => r.address,
                 :city => r.city,
                 :state => r.state,
                 :zip_code => r.zip_code,
                 :county => r.county
               ) if player.nil?
    registration.player = player
  end

end
