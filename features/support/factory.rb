
def create_schedule_from_slug(slug)
  create_schedule(nil, slug)   #use slug as schedule name, since we don't care
end

def create_schedule(slug, schedule_name)
  Schedule.create!( :slug => slug, :name => schedule_name)
end

def create_tournament(tournament)
  Tournament.create!(
      :slug => tournament['slug'].downcase,
      :name => tournament['name'],
      :location => tournament['location'],
      :event_date => Date::strptime(tournament['event_date'], '%Y-%m-%d'),
      :short_description => tournament['short_description'],
      :registration => tournament['registration']
  )
end

def create_schedule_tournaments(schedule,tournaments)
  tournaments.hashes.each do |tournament|
    schedule.tournaments << create_tournament(tournament)
  end
end

def create_tournaments(tournament_table)
  tournaments = []
  tournament_table.hashes.each do |tournament|
    tournaments << create_tournament(tournament)
  end
  tournaments
end