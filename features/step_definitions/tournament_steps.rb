Given(/^(?:a|the) tournament with slug "(.*?)" does not exist$/) do |tournament_slug|
  Tournament.delete_all(["slug = ?", tournament_slug] )
end

Then(/^exactly one tournament with slug "(.*?)" should exist$/) do |tournament_slug|
  Tournament.find_all_by_slug(tournament_slug).length.should be 1
end

Given /^(?:a|the)? tournaments? exists?:$/ do |tournaments|
  create_tournaments(tournaments)
end
