class RegistrationsController < ApplicationController

  respond_to :html

  def new
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build
    respond_with(@registration)
  end

  def create

    prev = params[:prev_tournament_id] ||= params[:registration][:tournament_id]
    if prev != params[:registration][:tournament_id]
      redirect_to "/players/#{params[:player_id]}"
      return
    end

    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build(params[:registration])

    if params[:player_id]
      player = Player.find(params[:player_id])
      #@registration = @tournament.registrations.build(params[:registration])
      fill_player_details(@registration, player)
      return_to = player
    else
      #@registration = @tournament.registrations.build(params[:registration])
      player = associate_player(@registration)
      player.valid?
      return_to = @tournament
    end

    if @registration.save
      if @registration.status == 'request'
       flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
                            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status == 'waiting list'
        flash[:registered] = "SECTION FULL!! #{@registration.first_name} #{@registration.last_name} is on the waiting list " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      end
      player.add_guardians @registration.guardians
      player.save
      redirect_to return_to
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

  def fill_player_details(registration, player)
    r,p = registration, player
    r.first_name = p.first_name
    r.last_name = p.last_name
    r.school = p.school
    r.grade = p.grade
    r.gender = p.gender
    r.date_of_birth = p.date_of_birth
    r.uscf_member_id = p.uscf_id
    r.guardian_emails = p.guardian_emails.join ' '
    r.address = p.address
    r.city = p.city
    r.zip_code = p.zip_code
    r.player = player
  end

  def associate_player(registration)
    r = registration
    player = Player.find_by_uscf_id(r.uscf_member_id) unless r.uscf_member_id.nil? or r.uscf_member_id.empty?
    player = Player.find_by_first_name_and_last_name_and_grade(r.first_name, r.last_name, r.grade) if player.nil?
    player = Player.new(
                 :first_name => r.first_name,
                 :last_name => r.last_name,
                 :uscf_id => r.uscf_member_id,
                 :school => r.school,
                 :grade => r.grade,
                 :date_of_birth => r.date_of_birth,
                 :gender => r.gender,
                 :address => r.address,
                 :city => r.city,
                 :state => r.state,
                 :zip_code => r.zip_code,
                 :county => r.county
               ) if player.nil?
    r.player = player
  end

end
