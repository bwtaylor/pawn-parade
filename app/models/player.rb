class Player < ActiveRecord::Base
  attr_accessible :address, :address2, :city, :county, :date_of_birth, :first_name,
                  :gender, :grade, :last_name, :school_year, :state, :uscf_id, :zip_code,
                  :uscf_rating_reg, :uscf_rating_reg_live, :uscf_status, :uscf_expires, :team_id

  belongs_to :team, :foreign_key => 'team_id'
  has_many :guardians

  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :uscf_id, :allow_blank => true, format: { with: /^\d{8}$/, message: 'id must be 8 digits' }
  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12)

  before_save :upcase

  def upcase
    self.first_name.upcase!
    self.last_name.upcase!
    self.state.upcase! if self.state
  end

  def pull_uscf
    require 'nokogiri'
    require 'open-uri'
    uri =  "http://www.uschess.org/datapage/player-search.php?name=#{uscf_id}&state=#{self.team.state}&rating=R&mode=Find"
    player_lookup_uri =  URI::encode(uri)
    doc = Nokogiri::HTML(open(player_lookup_uri));
    results = doc.css('table.blog table tr:nth-child(3) td')
    #"15315374   563   572   Unrated   TX   Non-Member   DILGER, SAM P\n"
    self.uscf_id = results[0].content.strip[0,8]
    self.uscf_rating_reg = results[1].content
    self.state = results[4].content unless self.state
    if results[5].content.to_s.start_with?('Non-Member')
      self.uscf_status = 'JTP'
    else
      #self.uscf_expires = Date.parse(results[5].content)
      self.uscf_expires = Date.strptime results[5].content, '%Y-%m-%d'      #'2014-03-31'
      self.uscf_status = self.uscf_expires <= Date.today ? 'EXPIRED' : 'MEMBER'
    end
    #self.first_name = results[6].content.split[', '][1] #unless self.first_name
    names = results[6].content.split(/, /)
    self.last_name = names[0] #unless self.last_name
    self.first_name = names[1]
    self.state = results[4].content unless self.state
  end

  def pull_live_rating
    require 'nokogiri'
    require 'open-uri'
    player_lookup_uri =  "http://www.uschess.org/datapage/player-search.php?name=#{uscf_id}&nextrating=N"
    doc = Nokogiri::HTML(open(player_lookup_uri));
    results = doc.css('table.blog table tr:nth-child(3) td')
    self.uscf_rating_reg_live = results[1]
  end

end
