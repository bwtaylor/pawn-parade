module RegistrationsHelper

  def reg_dump_header
    "id\tplayer_id\tsection\tname\tteam\tschool\tgrade\tuscf_id\tstatus\trating\tgender\tdob\tstreet\tcity\tstate\tzip_code\tfull_team\tbye_requests\tguardian_emails\tteam_slug\tproblem\n"
  end

  def reg_dump(registration)
    r = registration
    full_team = "#{r.player.team.full_name if r.player.team}"
    guardian_emails = Guardian.find_all_by_player_id(r.player.id).map{|g| g.email}.join(',')
    team_slug = r.player.team.nil? ? team(r.school) : r.player.team.slug

    mpa = TagDef.find_by_entity_class_and_tag('Player','mpa')
    problem = ''
    problem += 'nompa' unless mpa.tagged?(r.player_id)

    reg_dump = "#{r.id}\t#{r.player_id}\t#{r.section}\t#{r.last_name}, #{r.first_name}\t#{r.player.team.name if r.player.team}\t"
    reg_dump += "#{r.school}\t#{r.grade}\t#{r.uscf_member_id}\t#{r.status}\t#{r.rating}\t#{r.gender}\t#{r.date_of_birth}\t"
    reg_dump += "#{r.address}\t#{r.city}\t#{r.state}\t#{r.zip_code}\t#{full_team}\t0\t#{guardian_emails}\t#{team_slug}\t#{problem}\n"
    reg_dump
  end

#  <% full_team = "#{r.player.team.full_name if r.player.team}" %>
#  <% guardian_emails = Guardian.find_all_by_player_id(r.player.id).map{|g| g.email}.join(',') %>
#  <% team_slug = r.player.team.nil? ? team(r.school) : r.player.team.slug %>
#    <% problem = problem(r.player_id) %>
#  <% regdump = "id\tplayer_id\tsection\tname\tteam\tschool\tgrade\tuscf_id\tstatus\trating\tgender\tdob\tstreet\tcity\tstate\tzip_code\tfull_team\tbye_requests\tguardian_emails\tteam_slug\tregistration_status\tproblem\n" %>
#  <% regdump += "#{r.id}\t#{r.player_id}\t#{r.section}\t#{r.last_name}, #{r.first_name}\t#{r.player.team.name if r.player.team}\t" %>
#  <% regdump += "#{r.school}\t#{r.grade}\t#{r.uscf_member_id}\t#{r.status}\t#{r.rating}\t#{r.gender}\t#{r.date_of_birth}\t" %>
#  <% regdump += "#{r.address}\t#{r.city}\t#{r.state}\t#{r.zip_code}\t#{full_team}\t0\t#{guardian_emails}\t#{team_slug}\t#{problem}\n" %>


  def uscf_batch_header
    "TYPE\tCODE\tID\tFN\tLN\tSEX\tADD1\tCITY\tSTATE\tZIP\tBIRTHDAY\tPMT\tGRADE\tAFFILID\tAFFIL\r\n"
  end

  def uscf_batch_fragment(registration)
    r = registration
    section = r.get_section
    #TYPE	CODE	FN	LN	SEX	ADD1	CITY	STATE	ZIP	BIRTHDAY	PMT	GRADE	AFFILID	AFFIL
    #N	Q0	Natalie	Herod	F	12 Weatherford	San Antonio	TX	78248	1/12/2006	TD	2	12430766	Bryan Taylor	H6023015	Blattman Elementary
    #N	UN1	Parker	Herod	M	12 Weatherford		San Antonio	TX	78248	12/17/2002	TD	5	12430766	Bryan Taylor	H6023015	Blattman Elementary

    type = 'N' if r.status.eql?('uscf id needed')
    type = 'R' if r.status.eql?('uscf membership expired')
    code = section.grade_max <= 3 ? 'Q0' : 'UN1'
    uscf_id = "#{r.player.uscf_id if type.eql?('R')}"
    payment = 'TD'
    dob = "#{r.date_of_birth.strftime('%m/%d/%Y') unless r.date_of_birth.nil?}"
    affiliate = r.player.team.uscf_affiliate_id unless r.player.team.nil?
    affiliate ||=  'H6023015'
    school = r.player.team.nil? ? r.school : r.player.team.name

    fragment = "#{type}\t#{code}\t#{uscf_id}\t#{r.first_name}\t#{r.last_name}\t#{r.gender}\t"
    fragment += "#{r.address}\t#{r.city}\t#{r.state}\t#{r.zip_code}\t"
    fragment += "#{dob}\t#{payment}\t#{k(r.grade)}\t#{affiliate}\t#{school}\r\n"
    fragment
  end

  def freshen_uscf(registrations)
    registrations.each do |r|
      p=r.player
      p.pull_uscf
      p.pull_live_rating
      p.save
      r.sync_from_player
    end
  end

  def freshen_players_with_new_uscf_id(tournament_id)
    regs = Registration.where(status: 'uscf id needed').where(tournament_id: tournament_id)
    regs.reject {|r| r.player.uscf_id.nil?}
    freshen_uscf(regs)
  end

  def freshen_expired_uscf(tournament_id)
    regs = Registration.where(tournament_id: tournament_id).where(status: 'uscf membership expired')
    freshen_uscf(regs)
  end

  def freshen_all_players_uscf(tournament_id)
    regs = Registration.where(tournament_id: tournament_id)
    regs = regs.reject {|r| ['duplicate','withdraw','spam'].include?(r.status)}
    freshen_uscf(regs)
  end

  def dollars(amount)
    amount_with_cents = number_with_precision(amount, :precision => 2)
    amount_with_cents.nil? ? '' : "$#{amount_with_cents}"
  end


end
