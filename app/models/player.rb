class Player < ActiveRecord::Base
  attr_accessible :address, :address2, :city, :county, :date_of_birth, :first_name,
                  :gender, :grade, :last_name, :school_year, :state, :uscf_id, :zip_code

  belongs_to :team, :foreign_key => 'team_id'

  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :uscf_id, :allow_blank => true, format: { with: /^\d{8}$/, message: 'id must be 8 digits' }
  validates_inclusion_of :grade,  :in => %w(K 1 2 3 4 5 6 7 8 9 10 11 12)

end
