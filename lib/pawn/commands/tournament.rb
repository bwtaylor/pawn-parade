desc 'manage tournaments'
long_desc 'This command is used to create and manage tournaments.'

command :tournament do |tournament|

  tournament.desc 'add a new tournament'
  tournament.long_desc <<________
Add a new tournament by specifying it's SLUG, LOCATION, and EVENT_DATE, defined as: \n
SLUG - a unique identifier for the tournament fit for use in a URI path  \n
NAME - the title of the tournament, as defined by its hosts \n
LOCATION - general name for where the tournament will occur (not the address) \n
EVENT_DATE - the date on which the event starts, format: "%Y-%m-%d" (eg: 2013-9-14) \n
SHORT_DESCRIPTION - a short (256 character) explanation of the tournament
________

  tournament.arg_name 'SLUG NAME LOCATION EVENT_DATE SHORT_DESCRIPTION'
  tournament.command :create do |create|
    create.action do | global_options, options, args |
      arguments_error_message =
          'you must specify a slug, name, location, event date, and short description to create a tournament'
      raise arguments_error_message if args.length < 5
      slug = args[0].downcase
      raise "Tournament #{slug} already exists." if Tournament.find_by_slug(slug)
      name = args[1]
      location = args[2]
      event_date = Date::strptime(args[3], "%Y-%m-%d")
      short_description = args[4]
      duplicates = Tournament.all(:conditions => {:location => location, :event_date => event_date})
      raise "Tournament duplicates location and event date of tournament #{duplicates[0].slug}." if duplicates.length > 0
      new_tournament = Tournament.create!(
          :slug=>slug,
          :name=>name,
          :location=>location,
          :event_date=>event_date,
          :short_description=>short_description)
      $stderr.puts "tournament #{new_tournament.slug} created" if new_tournament
    end
  end
end
