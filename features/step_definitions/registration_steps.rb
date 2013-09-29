
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
  found = false
  tournament.registrations.each { |reg| found ||= (reg.first_name == first_name) }
  assert found
end