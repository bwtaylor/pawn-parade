desc 'manage tournaments'
long_desc 'This command is used to create and manage tournaments.'

command :tournament do |tournament|

  tournament.desc 'add a new tournament'
  tournament.long_desc <<________
Add a new tournament by specifying it's SLUG, NAME, LOCATION, EVENT_DATE, and SHORT_DESCRIPTION defined as: \n
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

  tournament.desc 'generate the pawn command to recreate an existing tournament'
  tournament.arg_name 'SLUG'
  tournament.command :export do |export|
    export.action do | global_options, options, args |
      if args.length == 0
        tournaments = Tournament.all.sort_by(:event_date)
      else
        tournament_slug = args[0].downcase
        tournaments = Tournament.find_all_by_slug(tournament_slug)
      end
      tournaments.each do |tournament|
        puts "pawn tournament create #{tournament.slug} \"#{tournament.name}\" "+
                 "\"#{tournament.location}\" #{tournament.event_date} \"#{tournament.short_description}\""
      end
      puts "# #{tournaments.length} tournaments exported"

    end
  end


  tournament.desc 'upload a flier in asciidoc format'
  tournament.long_desc <<________
Upload a flier in asciidoc format.
________

  require 'open-uri'
  tournament.arg_name 'SLUG'
  tournament.command :flier do |flier|
    flier.arg_name 'FILENAME'
    flier.flag [:f,:file]
    flier.arg_name 'URI'
    flier.flag [:u,:uri]
    flier.action do | global_options, options, args |
      filename=options[:file]
      uri=options[:uri]
      raise 'You must specify an input location from either a file or uri' if filename.nil? & uri.nil?
      raise 'You cannot specify both a file and a uri' unless filename.nil? | uri.nil?
      io_source = uri.nil? ? filename : uri
      io_stream = open(io_source)
      raise 'content cannot exceed 4000 characters' if io_stream.size > 4000
      content = io_stream.read(4000)
      tournament_slug=args[0]
      raise 'you must specify tournament slug' if tournament_slug.nil?
      tournament = Tournament.find_by_slug(tournament_slug)
      raise "no tournament exists with slug #{tournament_slug}"  if tournament.nil?
      tournament.description_asciidoc = content
      tournament.save!
      puts "uploaded description for tournament #{tournament.slug} from #{io_source}"
    end
  end
end
