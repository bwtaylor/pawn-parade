Given /^a schedule named "(.*?)" exists$/ do |schedule_name|
  @schedule = Schedule.create!( :name => schedule_name)
end 

Given /^the schedule has tournaments:$/ do |tournaments|
  tournaments.rows.each  do |tournament|
    @schedule.tournaments << Tournament.create!(
      :location => tournament[0],
      :event_date => Date::strptime(tournament[1], "%Y-%m-%d")
    )
  end
end

