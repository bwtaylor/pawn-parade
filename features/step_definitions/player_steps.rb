Given(/^these players exist:$/) do |player_table|
  player_table.hashes.each do |player_hash|
    player = Player.create(
        :first_name => player_hash['first_name'],
        :last_name => player_hash['last_name'],
        :uscf_id => player_hash['uscf_id'],
        :grade => player_hash['grade']
    )
    guardian_emails = player_hash['guardians'].split /\s+|\s*;\s*|\s,\s*/
    guardian_emails.each do |email|
      player.guardians.build(:email=>email).save!
    end
  end
end