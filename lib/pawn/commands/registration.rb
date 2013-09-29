desc 'manage tournament registration'
long_desc 'This command is used to control tournament registration metadata.'

arg_name 'TOURNAMENT_SLUG'
command :registration do |registration|
  registration.desc 'turn ON registration'
  registration.switch :on
  registration.desc 'turn OFF registration'
  registration.switch :off
  registration.long_desc <<________
  The registration command can be used to toggle whether registration is managed through this pawn parade deployment
with the --on and --off flags. Only one may be used at a time, and it must be included with the
TOURNAMENT_SLUG - argument identifying a tournament via its slug
________

  registration.action do | global_options, options, args |
    on_off = 'on' if on = options[:on]
    on_off = 'off' if off = options[:off]
    raise 'Cannot set both --on and --off' if on & off
    tournament_slug = args[0]
    raise 'you must specify tournament slug' if tournament_slug.nil?
    tournament = Tournament.find_by_slug(tournament_slug)
    raise "no tournament exists with slug #{tournament_slug}"  if tournament.nil?
    if on
      preregistration_sections = tournament.sections.find_all {|sect| sect.status == 'preregistration'}
      raise "tournament #{tournament_slug} has no sections, can't enable registration" if preregistration_sections.length == 0
    end
    if on_off
      tournament.registration = on_off
      tournament.save!
      puts "registration #{on_off} for tournament #{tournament.slug}"
    end
  end

end



#`pawn registration --on rax`
