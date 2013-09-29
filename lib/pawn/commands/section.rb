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

end
