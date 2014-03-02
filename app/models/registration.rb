class Registration < ActiveRecord::Base

  attr_accessible :section,
                  :status,
                  :score,
                  :prize,
                  :team_prize,
                  #####
                  :first_name,
                  :last_name,
                  :school,
                  :grade,
                  #:guardian_emails,
                  :uscf_member_id,
                  :date_of_birth,
                  :address,
                  :city,
                  :state,
                  :zip_code,
                  :county,
                  :gender,
                  :rating


  belongs_to :tournament #, :class_name => 'Tournament', :foreign_key => 'tournament_id'
  belongs_to :player

  validates :section, :presence => true, :length => { :maximum => 40 }
  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :school, :presence => true, :length => { :maximum => 80 }
  validates :uscf_member_id, :allow_blank => true, format: { with: /^\d{8}$/, message: "id must be 8 digits" }

  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12)
  validates_inclusion_of :gender, :in => %w(M F)

  validates_inclusion_of :shirt_size, :allow_nil => true,
    :in => ['Youth Small (6-8)', 'Youth Medium (10-12)', 'Youth Large (14-16)', 'Adult Small', 'Adult Medium', 'Adult Large', 'Adult XL']

  validates_inclusion_of :status, :allow_nil => true,
    :in => [
      'request',                 # submitted through website, needing admin approval
      'waiting list',            # section is full
      'duplicate',               # automated or manually discarded as duplicate
      'preregistered',           # approved preregistration request, spot is held for player
      'uscf membership expired', # request for rated section, but USCF membership is expired: must renew by tny time or withdraw
      'uscf id needed',          # request for rated section, but no valid USCF member id provided: provide or withdraw
      'spam',                    # moderator discarded as junk
      'registered',              # checked in at tny, will play in section
      'no show',                 # preregistered by has not check in by end of check in
      'withdraw'                 # voluntarily withdraw, before or after playing
    ]

  validate :name_matches_player, :section_eligibility, append: true

  def name_matches_player
    errors.add(:last_name, 'Last Name must match USCF') unless self.last_name.upcase == self.player.last_name
    errors.add(:first, 'First Name must be similar to USCF') unless self.player.first_name.include?(self.first_name.upcase)
  end

  def section_eligibility
    section = get_section
    if section.nil?
      errors.add(:section, 'Invalid Section')
    else
      grade = (self.grade == 'K') ? 0 : self.grade.to_i
      errors.add(:section, 'Grade Too High for Section') unless grade <= section.grade_max
      errors.add(:section, 'Grade Too Low for Section')  unless grade >= section.grade_min
      #if section.rated & !section.rating_cap.nil? & self.player.uscf_rating_reg.nil? & (self.player.uscf_rating_reg >= section.rating_cap)
      if section.rated and (self.player.uscf_rating_reg ||= 0) >= (section.rating_cap ||= 9999)
        errors.add(:section, 'Rating Too High for Section')
      end
    end
  end

  before_save :default_values

  def default_values
    self.status ||= self.get_section.full? ? 'waiting list' : 'request'
    self.uscf_member_id = nil if self.uscf_member_id.blank?
  end

  def get_section
    Section.find_by_tournament_id_and_name(self.tournament.id, self.section)
  end

end
