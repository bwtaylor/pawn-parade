class Registration < ActiveRecord::Base

  attr_accessible :section,
                  :first_name,
                  :last_name,
                  :school,
                  :grade,
                  :uscf_member_id,
                  :shirt_size,
                  :status,
                  :rating,
                  :score,
                  :prize,
                  :team_prize

  belongs_to :tournament, :class_name => 'Tournament', :foreign_key => 'tournament_id'

  validates :section, :presence => true, :length => { :maximum => 40 }
  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :school, :presence => true, :length => { :maximum => 80 }
  validates :uscf_member_id, :allow_blank => true, format: { with: /^\d{8}$/, message: "id must be 8 digits" }

  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12)

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

  validate :section_eligibility

  def section_eligibility
    section_names = self.tournament.sections.collect {|section| section.name}
    errors.add(:section, 'Ineligible for Section') if ! section_names.include? self.section

    min_grade = self.section[ /\((K|\d{1,2})-(K|\d{1,2})\)/ , 1]
    max_grade = self.section[ /\((K|\d{1,2})-(K|\d{1,2})\)/ , 2]

    if (!min_grade.nil? & !max_grade.nil?)
      min_grade = min_grade == 'K' ? 0 : min_grade.to_i;
      max_grade = max_grade == 'K' ? 0 : max_grade.to_i;
      grade = self.grade == 'K' ? 0 : self.grade.to_i;

      errors.add(:grade, 'Grade Too High for Section') if grade > max_grade
      errors.add(:grade, 'Grade Too Low for Section')  if grade < min_grade
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
