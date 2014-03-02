Given /^these players exist:$/ do |player_table|
  player_table.hashes.each do |player_hash|
    player = Player.create(
        :first_name => player_hash['first_name'],
        :last_name => player_hash['last_name'],
        :uscf_id => player_hash['uscf_id'],
        :grade => player_hash['grade']
    )
    guardian_emails = player_hash['guardians'].split /\s+|\s*;\s*|\s,\s*/
    player.add_guardians guardian_emails
  end
end

Given /^player ([^\s]*) ([^\s]*) does not exist$/ do |first_name, last_name|
  Player.delete_all(['first_name = ? and last_name = ?', first_name, last_name] )
end


Given /^player ([^\s]*) ([^\s]*) exists in grade (.*)$/ do |first_name, last_name, grade|
  Player.create(
      :first_name => first_name,
      :last_name => last_name,
      :grade => grade
  )
end

Then /^player ([^\s]*) ([^\s]*) should exist$/ do |first_name, last_name|
  Player.find_all_by_first_name_and_last_name(first_name, last_name).length.should be >= 1
end

Then(/^player ([^\s]*) ([^\s]*) should have (\d+) guardians$/) do |first_name, last_name, expected_number|
  player = Player.find_by_first_name_and_last_name(first_name, last_name)
  expect(player.guardians.length).to eq expected_number.to_i
end