class Team < ActiveRecord::Base
  attr_accessible :name, :slug, :full_name, :city, :county, :state, :school_district, :uscf_affiliate_id

  has_many :players
  has_many :team_managers
  has_many :managers, :through => :team_managers, source: :user

  def to_param
    slug
  end

  def freshen_uscf
    self.players.each do |p|
      p.uscf
      p.save
    end
  end

end
