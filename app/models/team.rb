class Team < ActiveRecord::Base
  attr_accessible :name, :slug
  has_many :team_managers
  has_many :managers, :through => :team_managers, source: :user

  def to_param
    slug
  end

end
