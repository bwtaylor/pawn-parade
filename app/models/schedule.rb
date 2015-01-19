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

  def page
    Page.find_by_page_type_and_slug('schedule',self.slug)
  end

  def future_events
    self.tournaments.select {|t| t[:event_date].to_datetime > Time.now() - 24*60*60 }
  end

  def past_events
    self.tournaments.select {|t| t[:event_date].to_datetime <= Time.now() - 24*60*60 }
  end

end
