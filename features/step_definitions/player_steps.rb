Given /^these players exist:$/ do |player_table|
  player_table.hashes.each do |player_hash|
    @given_player = Player.create!(
        :first_name => player_hash['first_name'],
        :last_name => player_hash['last_name'],
        :school => player_hash['school'],
        :uscf_id => player_hash['uscf_id'],
        :grade => player_hash['grade'],
        :gender => player_hash['gender'],
        :uscf_rating_reg => (player_hash['uscf_rating_reg'] ||= player_hash['rating']),
        :uscf_rating_reg_live => (player_hash['uscf_rating_reg_live'] ||= player_hash['live_rating'])
    )
    guardian_emails = "#{player_hash['guardians']}".split /\s+|\s*;\s*|\s,\s*/
    @given_player.add_guardians guardian_emails
  end
end

Given /^player ([^\s]*) ([^\s]*) does not exist$/ do |first_name, last_name|
  Player.delete_all(['first_name = ? and last_name = ?', first_name, last_name] )
end


Given /^player ([^\s]*) ([^\s]*) exists in grade (.*)$/ do |first_name, last_name, grade|
  @given_player = Player.create(
      :first_name => first_name,
      :last_name => last_name,
      :grade => grade
  )
end

Then /^player ([^\s]*) ([^\s]*) should exist$/ do |first_name, last_name|
  players = Player.where('first_name like ?',"#{first_name}%").where('last_name = ?', last_name)
  players.length.should be 1
end

Then(/^player ([^\s]*) ([^\s]*) should have (\d+) guardians$/) do |first_name, last_name, expected_number|
  player = Player.where('first_name like ?',"#{first_name}%").where('last_name = ?', last_name)[0]
  expect(player.guardians.length).to eq expected_number.to_i
end

Then(/^player ([^\s]*) ([^\s]*) should have school "(.*)"$/) do |first_name, last_name, expected_school|
  player = Player.where('first_name like ?',"#{first_name}%").where('last_name = ?', last_name)[0]
  expect(player.school).to eq expected_school
end


Then /^exactly one player with USCF Id (\d+) should exist$/ do |uscf_id|
  players = Player.find_all_by_uscf_id(uscf_id)
  players.length.should be 1
  @player = players.first
end

Then /^this player should be the given player$/ do
  @player.id.should be @given_player.id
end
