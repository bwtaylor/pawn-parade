class Player < ActiveRecord::Base

  require 'nokogiri'
  require 'open-uri'

  attr_accessible :address, :address2, :city, :county, :date_of_birth, :first_name,
                  :gender, :grade, :last_name, :school_year, :state, :uscf_id, :zip_code,
                  :uscf_rating_reg, :uscf_rating_reg_live, :uscf_status, :uscf_expires, :team_id

  belongs_to :team, :foreign_key => 'team_id'
  has_many :guardians
  has_many :registrations

  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :uscf_id, :allow_blank => true, format: { with: /^\d{8}$/, message: 'id must be 8 digits' }
  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12)

  before_validation :upcase
  after_validation :rating

  def upcase
    self.first_name.upcase!
    self.last_name.upcase!
    self.state.upcase! if self.state
  end

  def rating
    changed = self.changed_attributes.has_key? 'uscf_id'
    if changed and self.uscf_id.length == 8
      pull_uscf
      pull_live_rating
    end
  end

  def add_guardians(guardian_emails)
    guardian_emails.each do |email|
      self.guardians.build(:email=>email).save! if Guardian.find_by_email_and_player_id(email, self.id).nil?
    end
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
    self.uscf_rating_reg
  end

  def pull_live_rating
    uri = "http://www.uschess.org/msa/MbrDtlTnmtHst.php?#{uscf_id}"
    doc = Nokogiri::HTML(open(uri));
    cells = doc.css('td.topbar-middle center table tr td table tr:nth-child(2) td b')
    self.uscf_rating_reg_live = cells[0].content if cells.length >= 1
  end

end
