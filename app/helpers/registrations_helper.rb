module RegistrationsHelper

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


end
