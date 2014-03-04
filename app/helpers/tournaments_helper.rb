module TournamentsHelper

  def upcoming_tournaments
    if @upcoming_tournaments.nil?
      today = Time.now.beginning_of_day
      @upcoming_tournaments = Tournament.where("registration = 'on' AND event_date >= :today", today: today).order(:event_date)
    end
    @upcoming_tournaments
  end

end
