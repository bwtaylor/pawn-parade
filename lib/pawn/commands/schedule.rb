desc 'manage schedules'
long_desc 'The schedule command manipulates named schedules of tournaments, around which leagues are built.'

command :schedule do |schedule|

  schedule.desc 'add a new schedule'
  schedule.long_desc <<________
add a new schedule with name given by SCHEDULE_NAME. The URI slug for this schedule
can be explicitly provided by the optional SLUG argument, or it will be set from
SCHEDULE_NAME by converting to lowercase and mapping spaces to an underbar.
________

  schedule.command :create do |create|
    create.arg_name 'SCHEDULE_NAME [SLUG]'
    create.action do | global_options, options, args |
      raise 'you must specify a schedule_name to create' if args.length < 1
      schedule_name = args[0]
      slug = Schedule.to_slug(args[1].nil? ? schedule_name : args[1])
      existing_schedules = Schedule.all( :conditions => {:slug => slug} )
      if existing_schedules.length > 0
        ap existing_schedules
        raise "schedule #{existing_schedules[0].slug} already exists"
      end
      new_schedule = Schedule.create!( :slug => slug, :name => schedule_name)
      $stderr.puts "schedule #{new_schedule.slug} created" if new_schedule
    end
  end

  schedule.desc 'list schedules'
  schedule.long_desc 'show the list of existing schedules'
  schedule.command :list do |list|
    schedules = Schedule.order('name').all
    list.action do | global_options, options, args |
      schedules.each do |schedule|
        puts schedule.name
      end
      $stderr.puts "#{schedules.length} schedules found"
    end
  end

  schedule.desc 'show a tournament schedule'
  schedule.long_desc 'show future tournaments for schedule, identified by it\'s slug'
  schedule.command :show do |show|
    show.arg_name 'schedule_slug'
    show.action do | global_options, options, args |
      raise 'you must specify a schedule_name to create' if args.length < 1
      schedule_slug= args[0]
      schedule = Schedule.find_by_slug(schedule_slug)
      raise "schedule #{schedule_slug} does not exist" if schedule.nil?
      schedule.tournaments.sort_by!{|t| t[:event_date]}.each do |tournament|
        puts "#{tournament.location} #{tournament.event_date}"
      end
      $stderr.puts "#{schedule.tournaments.length} tournaments found"
    end
  end

  schedule.desc 'include a tournament on a schedule'
  schedule.long_desc 'take an already existing tournament, identified by it\'s slug, and add it to a schedule, identified by it\'s slug'
  schedule.arg_name 'tournament_slug'
  schedule.command :add do |add|
    add.desc 'schedule to add the tournament to'
    add.arg_name 'SCHEDULE_SLUG'
    add.flag [:s,:to]
    add.action do | global_options, options, args |
      schedule_slug=options[:to]
      tournament_slug=args[0]
      raise 'must specify a schedule with -s or --to' if schedule_slug.nil?
      to_schedule=Schedule.find_by_slug(schedule_slug)
      raise "schedule #{schedule_slug} does not exist" if to_schedule.nil?
      raise 'must specify a tournament' if tournament_slug.nil?
      tournament=Tournament.find_by_slug(tournament_slug)
      raise "Tournament #{tournament_slug} does not exist" if tournament.nil?
      puts "including tournament #{tournament.slug} on schedule #{to_schedule.name}"
      to_schedule.tournaments << tournament
    end
  end

end
