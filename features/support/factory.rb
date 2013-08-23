
def create_schedule(schedule_name)
  Schedule.create!( :name => schedule_name)
end

def create_schedule_tournaments(schedule,tournaments)
  tournaments.rows.each  do |tournament|
    schedule.tournaments << Tournament.create!(
        :location => tournament[0],
        :event_date => Date::strptime(tournament[1], "%Y-%m-%d")
    )
  end
end
