class RegistrationsController < ApplicationController

  respond_to :html

  before_filter(:only => :index) do |controller|
    authorize_admin if controller.request.format.txt?
  end

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
      @return_to ||= url_for player
    else
      player = @registration.associate_player
      player.valid?
      @return_to ||= url_for @tournament
    end

    if @registration.save
      if @registration.status.eql? 'request'
       flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
                            " in the \"#{@registration.section}\" section of #{@tournament.name}"
      elsif @registration.status.eql? 'uscf id needed'
        flash[:registered] = "#{@registration.first_name} #{@registration.last_name} is preregistered " +
            " in the \"#{@registration.section}\" section of #{@tournament.name}, but NEEDS USCF MEMBERSHIP"
      elsif @registration.status.eql? 'uscf membership expired'
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
    reject = %w(duplicate withdraw spam)
    @registrations = @tournament.registrations.reject { |r| reject.include? r.status }
    respond_to do |format|
      format.html
      format.txt
    end
  end

  def update
    change_section
  end

  def change_section
    @tournament = Tournament.find_by_slug(params[:tournament_id])
    player = Player.find(params[:player_id])
    player.pull_uscf
    player.pull_live_rating
    player.save!
    @return_to = params[:return_to]

    registrations = Registration.find_all_by_tournament_id_and_player_id(@tournament.id,player.id)
    @registration = registrations[0]
    dup_registrations = registrations[1..-1]

    @registration.sync_from_player

    new_section = params[:registration][:section]
    section_changed = new_section.eql?(@registration.section)
    new_status =  params[:registration][:status]
    status_same = new_status.eql?(@registration.status)
    new_status = 'request' if section_changed && status_same

    @registration.status = new_section.empty? ? 'withdraw' : new_status
    @registration.section = @registration.status.eql?('duplicate') ? '' : new_section

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
      dup_registrations.each do |r|
        r.status = 'duplicate'
        r.section = ''
        r.save
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
    r.guardian_emails = p.guardian_emails
    r.address = p.address
    r.city = p.city
    r.state = p.state
    r.zip_code = p.zip_code
    r.player = player
  end

end
