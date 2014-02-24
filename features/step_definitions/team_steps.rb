
Given(/^team (.*) exists with slug (.*)/) do  |team, slug|
  Team.create!(:name=>team, :slug=>slug)
end

Given(/^team (.*) has state (.*)/) do  |team_slug, state|
  team = Team.find_by_slug(team_slug)
  team.state = state
  team.save!
end


Given(/^(.*) does not manage a team$/) do |user_email|
  user = User.find_by_email(user_email)
  assert(user.managed_teams.size == 0)
end

Given(/^(.*) manages (.*)$/) do |user_email, team_slug|
  user = User.find_by_email(user_email)
  team = Team.find_by_slug(team_slug)
  raise "no team has slug #{team_slug}" if team.nil?
  user.managed_teams << team unless user.managed_teams.include? team
end

Given(/^(.*) manages (.*) with state (.*) $/) do |user_email, team_slug, state|
  user = User.find_by_email(user_email)
  team = Team.find_by_slug(team_slug)
  team.state = state
  raise "no team has slug #{team_slug}" if team.nil?
  user.managed_teams << team unless user.managed_teams.include? team
end

Then(/^(.*) should manage (.*)$/) do  |user_email, team_slug|
  user = User.find_by_email(user_email)
  team = Team.find_by_slug(team_slug)
  user.managed_teams.include?(team).should be true
end

Then(/^the dashboard team list includes (.*)/) do |team_slug|
  team = Team.find_by_slug(team_slug)
  #may break when dashboard contains tournaments that may also hit
  page.should have_content team.name
end

Given(/^the (.*) team has no players$/) do |team_slug|
  team = Team.find_by_slug(team_slug)
  team.players=[]
end

Given(/^the (.*) team has players:$/) do |team_slug, player_table|
  team = Team.find_by_slug(team_slug)
  player_table.hashes.each do |player_hash|
    player = Player.create(
        :first_name => player_hash['first_name'],
        :last_name => player_hash['last_name'],
        :uscf_id => player_hash['uscf_id'],
        :grade => player_hash['grade']
    )
    team.players << player
  end
end