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

Given(/^the tournament has sections:$/) do |section_table|
  sr = section_table.raw
  sf = sr.flatten
  sf.each do |section_name|
    section = @tournament.sections.build(:name=>section_name)
    section.save!
  end
  @tournament.save!
end
