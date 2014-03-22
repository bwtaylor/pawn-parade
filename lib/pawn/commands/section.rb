desc 'manage tournament sections'
long_desc 'This command is used to control tournament section metadata.'

command :section do |section|
  section.desc 'upload a list of named sections'
  section.arg_name '[SECTION_NAME]*', :multiple
  section.long_desc <<________
  Import does a bulk insert of sections. In case of collisions (by name) processing continues,
but only the old section exists. The section slug, rated flag, and status will be autopopulated.
TOURNAMENT_SLUG - argument identifying a tournament via its slug
SECTION_NAME - the general name of the section
________

  # pawn section import --to jayhs-fall-2013 "Primary Unrated" "Elementary Unrated" "U500" "Open Rated" "Middle School Unrated" "HS Unrated"
  section.command :import do |import|
    import.desc 'tournament to import to'
    import.arg_name 'TOURNAMENT_SLUG'
    import.flag :to
    import.action do | global_options, options, args |
      tournament_slug=options[:to]
      raise 'must specify a tournament by passing its slug to --to' if tournament_slug.nil?
      tournament = Tournament.find_by_slug(tournament_slug)
      raise "no tournament with slug #{tournament_slug} eixsts" if tournament.nil?
      args.each do |section_name|
        if Section.find_by_tournament_id_and_name(tournament.id, section_name).nil?
          section = tournament.sections.build(:name => section_name)
          section.save!
        end
      end
      total_count = rated_count = unrated_count = 0
      Section.find_all_by_tournament_id(tournament.id).each do |section|
        total_count += 1
        rated_count += 1 if section.rated
        unrated_count += 1 if !section.rated
      end
      puts "Tournament #{tournament.slug} has #{total_count} sections, #{rated_count} rated, #{unrated_count} unrated"
    end
  end

  # pawn section list --for jayhs-fall-2013
  section.command :list do |list|
    list.desc 'tournament to list sections for'
    list.arg_name 'TOURNAMENT_SLUG'
    list.flag :for
    list.action do | global_options, options, args |
      tournament_slug=options[:for]
      raise 'must specify a tournament by passing its slug to --for' if tournament_slug.nil?
      tournament = Tournament.find_by_slug(tournament_slug)
      raise "no tournament with slug #{tournament_slug} exists" if tournament.nil?
      total_count = rated_count = unrated_count = 0
      Section.find_all_by_tournament_id(tournament.id).each do |section|
        rating_type = section.rated ? 'rated' : 'unrated'
        puts "#{section.slug} [#{rating_type}]"
        total_count += 1
        rated_count += 1 if section.rated
        unrated_count += 1 if !section.rated
      end
      puts "Tournament #{tournament.slug} has #{total_count} sections, #{rated_count} rated, #{unrated_count} unrated"
    end
  end

  #pawn section rated primary_jtp --for jayhs-fall-2013
  section.arg_name 'SECTION_SLUG'
  section.command :rated do |rated|
    rated.action do | global_options, options, args |
      tournament_slug=options[:for]
      raise 'must specify a tournament by passing its slug to --for' if tournament_slug.nil?
      tournament = Tournament.find_by_slug(tournament_slug)
      raise "no tournament with slug #{tournament_slug} exists" if tournament.nil?
      arguments_error_message = 'you must specify the SECTION_SLUG argument'
      raise arguments_error_message if args.length < 1
      section_slug = args[0].downcase
      section = Section.find_by_tournament_id_and_slug(tournament.id, section_slug)
      raise "No section #{section_slug} exists for tournament #{tournament_slug} " if section.nil?
      section.rated = true
      section.save!
      rating_type = section.rated ? 'rated' : 'unrated'
      puts "#{section.slug} [#{rating_type}]"
    end
  end

  #pawn section quota primary_jtp --for jayhs-fall-2013 --max 32
  section.arg_name 'SECTION_SLUG'
  section.command :quota do |quota|
    quota.desc 'max quota for section'
    quota.arg_name 'QUOTA'
    quota.flag :max
    quota.action do | global_options, options, args |
      tournament_slug=options[:for]
      raise 'must specify a tournament by passing its slug to --for' if tournament_slug.nil?
      tournament = Tournament.find_by_slug(tournament_slug)
      raise "no tournament with slug #{tournament_slug} exists" if tournament.nil?
      arguments_error_message = 'you must specify the SECTION_SLUG argument'
      raise arguments_error_message if args.length < 1
      section_slug = args[0].downcase
      section = Section.find_by_tournament_id_and_slug(tournament.id, section_slug)
      raise "No section #{section_slug} exists for tournament #{tournament_slug} " if section.nil?
      raise "Argument #{options[:max]} for --max is not a non-negative integer" unless options[:max].to_i >= 0
      max=options[:max].to_i
      section.max = max
      section.save!
      all_registrations = Registration.find_all_by_tournament_id_and_section(tournament.id,section.name)
      counted_registrations = all_registrations.reject{|r| ['duplicate', 'withdraw', 'spam', 'no show'].include?(r.status)}
      rating_type = section.rated ? 'rated' : 'unrated'
      puts "#{section.slug} [#{rating_type}] [#{counted_registrations.length}/#{section.max}]"
    end
  end

end

