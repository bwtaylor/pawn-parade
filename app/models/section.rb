class Section < ActiveRecord::Base
  attr_accessible :name, :slug, :rated, :status
  belongs_to :tournament, :class_name => 'Tournament', :foreign_key => 'tournament_id'


  validates_inclusion_of :status, :allow_nil => true,
    :in =>  %w(preregistration checking-in late-registration roster-locked completed cancelled posted-to-uscf)

  before_save :default_values

  def default_values
    self.slug ||= self.name.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
    self.rated ||= !self.name.downcase[/(?<!un)rated/].nil? | !self.name.downcase[/u\d{3,4}/].nil?
    self.status ||= 'preregistration'
  end

end



