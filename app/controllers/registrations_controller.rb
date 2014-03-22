class RegistrationsController < ApplicationController

  respond_to :html

  def new
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build
    respond_with(@registration)
  end

  def create

    @return_to = params[:return_to]

    prev = params[:prev_tournament_id] ||= params[:registration][:tournament_id]
    if prev != params[:registration][:tournament_id]
      redirect_to "/players/#{params[:player_id]}"
      return
    end

    @tournament = Tournament.find_by_slug(params[:tournament_id])
    @registration = @tournament.registrations.build(params[:registration])

    if params[:player_id]
      player = Player.find(params[:player_id])
      fill_player_details(@registration, player)
      @return_to ||= player
    else
      player = @registration.associate_player
      player.valid?
      @return_to ||= @tournament
    end

    if @registration.save
      if @registration.status.eql? 'request'
       flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
                            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status.eql? 'uscf id needed'
        flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}, but NEEDS USCF MEMBERSHIP"
      elsif @registration.status.eql? 'uscf id needed'
        flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}, but NEEDS TO RENEW USCF MEMBERSHIP"
      elsif @registration.status == 'waiting list'
        flash[:registered] = "SECTION FULL!! #{@registration.first_name} #{@registration.last_name} is on the waiting list " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      end
      player.add_guardians @registration.guardians
      player.save
      redirect_to @return_to
    else
      render :new
    end
  end

  def index
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    reject = ['duplicate', 'withdraw', 'spam']
    @registrations = @tournament.registrations.reject { |r| reject.include? r.status }
  end

  def update
    change_section
  end

  def change_section
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    player = Player.find(params[:player_id])
    @return_to = params[:return_to]
    @registration = Registration.find_by_tournament_id_and_player_id(@tournament.id,player.id)

    new_section = params[:registration][:section]
    section_changed = new_section.eql?(@registration.section)
    new_status =  params[:registration][:status]
    status_same = new_status.eql?(@registration.status)
    new_status = 'request' if section_changed && status_same
    @registration.status = new_section.empty? ? 'withdraw' : new_status
    @registration.section = new_section

    if @registration.save
      if @registration.status == 'request'
        flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status == 'waiting list'
        flash[:registered] = "SECTION FULL!! #{@registration.first_name} #{@registration.last_name} is on the waiting list " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status == 'withdraw'
        flash[:registered] = "#{@registration.first_name} #{@registration.last_name} has withdrawn from #{@tournament.name}"
      end
      redirect_to @return_to
    else
      render :new
    end
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

end
