
def create_schedule(schedule_name)
  Schedule.create!( :name => schedule_name)
end

def create_tournament(tournament)
  Tournament.create!(
      :slug => tournament['slug'].downcase,
      :name => tournament['name'],
      :location => tournament['location'],
      :event_date => Date::strptime(tournament['event_date'], '%Y-%m-%d'),
      :short_description => tournament['short_description']
  )
end

def create_schedule_tournaments(schedule,tournaments)
  tournaments.hashes.each do |tournament|
    schedule.tournaments << create_tournament(tournament)
  end
end

def create_tournaments(tournaments)
  tournaments.hashes.each do |tournament|
    create_tournament(tournament)
  end
end