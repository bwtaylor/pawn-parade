class Schedule < ActiveRecord::Base
  attr_accessible :name
  has_many :schedule_tournaments
  has_many :tournaments, :through => :schedule_tournaments
  
  def to_param
    name
  end
end
