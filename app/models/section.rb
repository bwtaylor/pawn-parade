class Section < ActiveRecord::Base
  attr_accessible :name, :slug, :rated, :status, :max
  belongs_to :tournament, :class_name => 'Tournament', :foreign_key => 'tournament_id'


  validates_inclusion_of :status, :allow_nil => true,
    :in =>  %w(preregistration full checking-in late-registration roster-locked completed cancelled posted-to-uscf)

  before_save :default_values

  def default_values
    self.slug ||= self.name.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
    self.rated ||= !self.name.downcase[/(?<!un)rated/].nil? | !self.name.downcase[/u\d{3,4}/].nil?
    self.status ||= 'preregistration'
  end

  def registration_count
    Registration.find_all_by_tournament_id_and_section(self.tournament_id,self.name).length
  end

  def full?
    full_by_fiat = self.status=='full'
    maxnil = self.max.nil?
    count = self.registration_count
    at_capacity = !maxnil && count >= self.max
    full_by_fiat | at_capacity
  end

end



