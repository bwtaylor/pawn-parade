
def create_schedule(schedule_name)
  Schedule.create!( :name => schedule_name)
end

def create_schedule_tournaments(schedule,tournaments)
  tournaments.hashes.each do |tournament|
    schedule.tournaments << Tournament.create!(
      :slug => tournament['slug'],
      :location => tournament['location'],
      :event_date => Date::strptime(tournament['event_date'], '%Y-%m-%d')
    )
  end
end

def create_tournaments(tournaments)
  tournaments.hashes.each do |tournament|
    Tournament.create!(
        :slug => tournament['slug'],
        :location => tournament['location'],
        :event_date => Date::strptime(tournament['event_date'], '%Y-%m-%d')
    )
  end
end