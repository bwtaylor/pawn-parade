class Player < ActiveRecord::Base

  require 'nokogiri'
  require 'open-uri'

  attr_accessible :address, :address2, :city, :county, :date_of_birth, :first_name,
                  :gender, :grade, :last_name, :school, :school_year, :state, :uscf_id, :zip_code,
                  :uscf_rating_reg, :uscf_rating_reg_live, :uscf_status, :uscf_expires, :team_id

  belongs_to :team, :foreign_key => 'team_id'
  has_many :guardians
  has_many :registrations

  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :school, :length => { :maximum => 80 }
  validates :uscf_id, :allow_blank => true, format: { with: /^\d{8}$/, message: "id must be 8 digits" }

  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12 99)
  validates_inclusion_of :gender, :in => %w(M F)

  before_validation :upcase
  after_validation :fetch_rating, :team_overrides_school

  def upcase
    self.first_name = self.first_name.strip.upcase
    self.last_name = self.last_name.strip.upcase
    self.state.upcase! if self.state
  end

  def rating(base)
    case base
      when 'regular'
        self.uscf_rating_reg
      when 'regular-live'
        self.uscf_rating_reg_live
      when Tournament
        rating(base.rating_type)
      when Registration
        rating(base.tournament.rating_type)
    end
  end

  def team_overrides_school
    self.school = self.team.name if self.team
  end

  def grade_display
    grade.eql?('99') ? 'Adult' : grade
  end

  def fetch_rating
    changed = self.changed_attributes.has_key? 'uscf_id'
    mock_data = !Rails.env.production? && self.uscf_id.starts_with?('0000')
    if changed && !mock_data && self.uscf_id.length == 8
      uscf
    end
  end

  def add_guardians(guardian_emails)
    unless guardian_emails.nil?
      email_list = guardian_emails.kind_of?(Array) ? guardian_emails : guardian_emails.split( /[\s,;:]+/ )
      email_list.each do |email|
        self.guardians.build(:email=>email, :player_id=>self.id).save! if Guardian.find_by_email_and_player_id(email, self.id).nil?
      end
    end
  end

  def guardian_emails
    self.guardians.collect { |guardian| guardian.email }.join("\n")
  end

  def uscf
    pull_uscf
    pull_live_rating
  end

  def pull_uscf
    uri =  "http://www.uschess.org/datapage/player-search.php?name=#{self.uscf_id}&state=ANY&rating=R&mode=Find"
    player_lookup_uri =  URI::encode(uri)
    doc = Nokogiri::HTML(open(player_lookup_uri));
    results = doc.css('table.blog table tr:nth-child(3) td')
    #"15315374   563   572   Unrated   TX   Non-Member   DILGER, SAM P\n"
    if results.length >= 7
      self.uscf_rating_reg = results[1].content
      self.state = results[4].content unless self.state
      if results[5].content.to_s.start_with?('Non-Member')
        self.uscf_status = 'JTP'
      else
        expiration = results[5].content
        expiration = '2100-01-01' if expiration.include?('Life')
        self.uscf_expires = Date.strptime expiration, '%Y-%m-%d'      #'2014-03-31'
        self.uscf_status = self.uscf_expires <= Date.today ? 'EXPIRED' : 'MEMBER'
      end
      names = results[6].content.split(/, /)
      self.last_name = names[0]
      self.first_name = names[1]
      self.state = results[4].content unless self.state
    end
    logger.info "#{self.last_name}, #{self.first_name} uscf=#{self.uscf_rating_reg} status=#{self.uscf_status} expires=#{self.uscf_expires}"
    self.uscf_rating_reg
  end

  def pull_live_rating
    mock_data = !Rails.env.production? && self.uscf_id.starts_with?('0000')
    return uscf_id[-3..-1].to_i * 10 if mock_data
    uri = "http://www.uschess.org/msa/MbrDtlTnmtHst.php?#{uscf_id}"
    doc = Nokogiri::HTML(open(uri));
    rowlist = doc.css('td.topbar-middle center table tr td table tr').collect{|r| r};
    header_rownum = rowlist.index { |r| r.content.include?('Reg Rtg') }
    if header_rownum.nil?
      live_rating = 0
    else
      rating_rownum = header_rownum + rowlist[header_rownum..-1].index{|r| /\d+/ === r.css('td')[2].css('b')[0] }
      live_rating = rowlist[rating_rownum].css('td b')[0].content
    end
    logger.info "#{last_name}, #{first_name} uscf_rating_reg_live=#{live_rating}"
    self.uscf_rating_reg_live = live_rating
  end

end
