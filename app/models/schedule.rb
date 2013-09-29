class Schedule < ActiveRecord::Base
  attr_accessible :slug, :name
  has_many :schedule_tournaments
  has_many :tournaments, :through => :schedule_tournaments
  
  def to_param
    slug
  end

  before_create :set_slug

  def set_slug
    self.slug ||= Schedule.to_slug(self.name)
  end

  def self.to_slug(text)
    text.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
  end

end
