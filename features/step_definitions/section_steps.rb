Given(/^the tournament has no sections$/) do
  assert(@tournament.sections.size == 0)
end

Then(/^the tournament should have (\d+) sections$/) do |digit_string|
  Section.find_all_by_tournament_id(@tournament.id).length.should be digit_string.to_i
end

Then(/^the tournament should have (\d+) rated sections$/) do |digit_string|
  Section.find_all_by_tournament_id_and_rated(@tournament.id, true).length.should be digit_string.to_i
end

Then(/^the tournament should have (\d+) unrated sections$/) do |digit_string|
  Section.find_all_by_tournament_id_and_rated(@tournament.id, false).length.should be digit_string.to_i
end

Given /^the tournament of interest has slug (.*)/ do |tournament_slug|
  @tournament = Tournament.find_by_slug  tournament_slug
end

Given(/^the tournament has sections:$/) do |section_table|
  sr = section_table.raw
  sf = sr.flatten
  sf.each do |section_name|
    section = @tournament.sections.build(:name=>section_name)
    section.save!
  end
  @tournament.save!
end

Then(/^section (.*) should be rated$/) do |section_slug|
  Section.find_by_tournament_id_and_slug(@tournament.id, section_slug).rated.should be true
end

Then(/^section (.*) should be unrated$/) do |section_slug|
  Section.find_by_tournament_id_and_slug(@tournament.id, section_slug).rated.should be false
end

Given(/^the quota for section "(.*?)" is (\d+)$/) do |section_name, max_quota|
  section = Section.find_by_tournament_id_and_name(@tournament.id, section_name)
  section.max= max_quota
  section.save!
end

Then(/^section (.*) should accept adults$/) do |section_slug|
  section = Section.find_by_tournament_id_and_slug(@tournament.id, section_slug)
  assert section.open_adults? , "Section grade max is #{section.grade_max} and should be 99"
end
