
Given(/^registration for the tournament is (on|off)$/) do |registration_state|
  @tournament.registration = registration_state
  @tournament.save!
end

Given(/^no registrations exist for the tournament$/) do
  assert(@tournament.registrations.size == 0)
end

Then(/^registration for the tournament should be (on|off)$/) do |tournament_slug, registration_state|
  assert(@tournament.registration == registration_state)
end

Then(/^registration for tournament (.*) should be (on|off)$/) do |tournament_slug, registration_state|
  tournament = Tournament.find_by_slug(tournament_slug)
  assert(tournament.registration == registration_state)
end

Then(/^(?:a )?registration should exist for (.*) (.*) in the "(.*)" section for tournament (.*)$/) do |first_name, last_name, section, tournament_slug|
  tournament = Tournament.find_by_slug(tournament_slug)
  @registration = Registration.find_by_tournament_id_and_first_name_and_last_name_and_section(tournament.id,first_name,last_name,section)
  found = !@registration.nil?
  assert found, "Registration for #{first_name} #{last_name} does not exist"
end