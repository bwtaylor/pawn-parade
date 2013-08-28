Given /^(?:a|the) schedule named "(.*?)" exists$/ do |schedule_name|
  @schedule = create_schedule(schedule_name)
end

Given(/^The existing schedules are:$/) do |table|
  schedules = table.raw.flatten
  Schedule.delete_all()
  schedules.each do |schedule_name|
    create_schedule(schedule_name)
  end
end


Given(/^(?:a|the) schedule named "(.*?)" does not exist$/) do |schedule_name|
  Schedule.delete_all(["name = ?", schedule_name] )
end

Given /^the schedule has tournaments:$/ do |tournaments|
  create_schedule_tournaments(@schedule, tournaments)
end

Given /^(?:a|the) schedule named "(.*?)" exists with tournaments:$/ do |schedule_name, tournaments|
  @schedule = create_schedule(schedule_name)
  create_schedule_tournaments(@schedule, tournaments)
end

Then /^(?:a|the) schedule named "(.*?)" should exist$/ do |schedule_name|
  matches =  Schedule.all( :conditions => {:name => schedule_name} )
  assert( matches.length > 0 , "#{schedule_name} not found")
end


