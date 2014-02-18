desc 'modify team managers'
long_desc 'The manager command can be used to set a user as a team manager'

command :manager do |cmd|

  cmd.desc 'associates user to team'
  cmd.long_desc <<________
Add a user, specified by email address, to manage a team, specified by slug.
________

  cmd.arg_name 'TEAM_SLUG'
  cmd.flag [:for]
  cmd.action do | global_options, options, args |
    team_slug=options[:for]
    user_email=args[0]
    team = Team.find_by_slug(team_slug)
    raise "no slug #{team_slug} found" if team.nil?
    user = User.find_by_email(user_email)
    raise "no user #{user_email} found" if user.nil?
    team.managers << user
    team.save!
    puts "made #{user.email} team manager for #{team.name}"
  end

end
