class Registration < ActiveRecord::Base

  attr_accessible :section,
                  :first_name,
                  :last_name,
                  :school,
                  :grade,
                  :uscf_member_id,
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

  validates_inclusion_of :status, :allow_nil => true,
    :in => [
      'request',                 # submitted through website, needing admin approval
      'duplicate',               # automated or manually discarded as duplicate
      'preregistered',           # approved preregistration request, spot is held for player
      'uscf membership expired', # request for rated section, but USCF membership is expired: must renew by tny time or withdraw
      'uscf id needed',          # request for rated section, but no valid USCF member id provided: provide or withdraw
      'spam',                    # moderator discarded as junk
      'registered',              # checked in at tny, will play in section
      'no show',                 # preregistered by has not check in by end of check in
      'withdraw'                 # voluntarily withdraw, before or after playing
    ]

  before_save :default_values

  def default_values
    self.status ||= 'request'
    self.uscf_member_id = nil if self.uscf_member_id.blank?
  end

end
