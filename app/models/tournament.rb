class Tournament < ActiveRecord::Base

  attr_accessible :slug, :name, :location, :event_date, :short_description,
                  :description_asciidoc, :registration, :registration_uri

  has_many :registrations, :class_name => 'Registration', :foreign_key => 'tournament_id'
  has_many :sections, :class_name => 'Section', :foreign_key => 'tournament_id'

  validates_inclusion_of :registration, :in => %w(on off), :allow_nil => true

  before_save :default_values

  def default_values
    self.registration ||= 'off'
  end

  def to_param
    slug
  end
end

