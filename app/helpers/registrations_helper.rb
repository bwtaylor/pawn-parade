module RegistrationsHelper

  def uscf_batch_header
    "TYPE\tCODE\tFN\tLN\tSEX\tADD1\tCITY\tSTATE\tZIP\tBIRTHDAY\tPMT\tGRADE\tAFFILID\tAFFIL\r\n"
  end

  def uscf_batch_fragment(registration)
    r = registration
    section = r.get_section
    #TYPE	CODE	FN	LN	SEX	ADD1	CITY	STATE	ZIP	BIRTHDAY	PMT	GRADE	AFFILID	AFFIL
    #N	Q0	Natalie	Herod	F	12 Weatherford	San Antonio	TX	78248	1/12/2006	TD	2	12430766	Bryan Taylor	H6023015	Blattman Elementary
    #N	UN1	Parker	Herod	M	12 Weatherford		San Antonio	TX	78248	12/17/2002	TD	5	12430766	Bryan Taylor	H6023015	Blattman Elementary

    type = 'N'
    code = section.grade_max <= 3 ? 'Q0' : 'UN1'
    payment = 'TD'
    affiliate = r.player.team.uscf_affiliate_id unless r.player.team.nil?
    affiliate ||=  'H6023015'
    school = r.player.team.nil? ? r.school : r.player.team.name


    fragment = "#{type}\t#{code}\t#{r.first_name}\t#{r.last_name}\t"
    fragment += "#{r.address}\t#{r.city}\t#{r.state}\t#{r.zip_code}\t"
    fragment += "#{r.date_of_birth}\t#{payment}\t#{k(r.grade)}\t#{affiliate}\t#{school}\r\n"
    fragment
  end

end
