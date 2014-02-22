class Team < ActiveRecord::Base
  attr_accessible :name, :slug, :full_name, :city, :county, :state, :school_district, :uscf_affiliate_id

  has_many :players
  has_many :team_managers
  has_many :managers, :through => :team_managers, source: :user

  def to_param
    slug
  end

end
