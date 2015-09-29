class Tournament < ActiveRecord::Base

  attr_accessible :slug, :name, :location, :event_date, :short_description,
                  :description_asciidoc, :registration, :registration_uri, :rating_type, :fee

  has_many :registrations, :class_name => 'Registration', :foreign_key => 'tournament_id'
  has_many :sections, :class_name => 'Section', :foreign_key => 'tournament_id'

  REGISTRATION_STATES =  %w(off on)
  RATING_TYPES = %w(regular regular-live)

  validates_inclusion_of :registration, :in => REGISTRATION_STATES, :allow_nil => true
  validates_inclusion_of :rating_type, :in => RATING_TYPES, :allow_nil => true #@todo: add quick and blitz

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

  def total_quota
    quotas = self.sections.collect{|s| s.max}
    all_positive = quotas.all? { |m| !m.nil? and m > 0}
    all_positive ? quotas.inject(:+) : nil
  end

  def open_adults?
    adult_sections = self.sections.select { |section| section.open_adults? }
    ! adult_sections.empty?
  end

  def grade_range
    self.open_adults? ? %w(K 1 2 3 4 5 6 7 8 9 10 11 12 99) : %w(K 1 2 3 4 5 6 7 8 9 10 11 12)
  end

  def grade_options_for_select
    options = %w(K 1 2 3 4 5 6 7 8 9 10 11 12).map {|g| [g,g]}
    options +=  [%w(Adult 99)] if self.open_adults?
    options
  end

  def to_param
    slug
  end
end

