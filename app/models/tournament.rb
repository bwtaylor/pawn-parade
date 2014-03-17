class Tournament < ActiveRecord::Base

  attr_accessible :slug, :name, :location, :event_date, :short_description,
                  :description_asciidoc, :registration, :registration_uri, :rating_type

  has_many :registrations, :class_name => 'Registration', :foreign_key => 'tournament_id'
  has_many :sections, :class_name => 'Section', :foreign_key => 'tournament_id'

  validates_inclusion_of :registration, :in => %w(on off), :allow_nil => true
  validates_inclusion_of :rating_type, :in => %w(regular regular-live), :allow_nil => true #@todo: add quick and blitz

  before_save :default_values

  def default_values
    self.registration ||= 'off'
    self.rating_type  ||= 'regular'
  end

  def registration_count
    excluded_statuses = ['withdraw', 'spam', 'duplicate', 'no show']
    regs = Registration.find_all_by_tournament_id(self.id)
    regs.reject{ |r| excluded_statuses.include?(r.status) }.length
  end

  def to_param
    slug
  end
end

