class Section < ActiveRecord::Base
  attr_accessible :name, :slug, :rated, :status, :max, :rating_cap, :grade_max, :grade_min, :fee
  belongs_to :tournament

  validates_inclusion_of :status, :allow_nil => true,
    :in =>  %w(preregistration full checking-in late-registration roster-locked completed cancelled posted-to-uscf)

  before_save :default_values

  def default_values
    self.slug ||= self.name.downcase.strip.gsub(' ', '_').gsub(/[^\w-]/, '')
    self.rating_cap ||= self.name.upcase[ /U(\d{3,4})/ , 1].to_i
    self.rated ||= !self.name.upcase[/(?<!UN)RATED/].nil? | (self.rating_cap > 0)
    self.rating_cap = nil if self.rating_cap == 0
    self.status ||= 'preregistration'

    section = self.name.upcase

    min_grade = section[ /.*(K|\d{1,2})-(K|\d{1,2}).*/ , 1]
    max_grade = section[ /.*(K|\d{1,2})-(K|\d{1,2}).*/ , 2]

    if max_grade.nil?
      max_grade = '1' if section.include?('SPROUT')
      max_grade = '3' if section.include?('PRIMARY')
      max_grade = '5' if section.include?('ELEMENTARY')
      max_grade = '8' if section.include?('MIDDLE')
      max_grade = '12' if section.include?('HIGH')
      max_grade = '99' if section.include?('OPEN')
    end
    min_grade = 'K' if min_grade.nil?
    max_grade = '12' if max_grade.nil?
    self.grade_min ||= (min_grade == 'K' ? 0 : min_grade.to_i)
    self.grade_max ||= (max_grade == 'K' ? 0 : max_grade.to_i)

  end

  def registration_count
    excluded_statuses = ['withdraw', 'spam', 'duplicate', 'no show']
    regs = Registration.find_all_by_tournament_id_and_section(self.tournament_id,self.name)
    regs.reject{|r| excluded_statuses.include?(r.status) }.length
  end

  def open_adults?
    grade_max.eql?(99)
  end

  def full?
    full_by_fiat = self.status=='full'
    maxnil = self.max.nil?
    count = self.registration_count
    at_capacity = !maxnil && count >= self.max
    full_by_fiat | at_capacity
  end

  def to_param
    slug
  end

  def to_txt
    registrations = Registration.find_all_by_tournament_id_and_section(self.tournament.id, self.name)
    for r in registrations do
      txt += "NAME = #{r.last_name}, #{r.first_name}\nTEAM = #{@team[r.school]}\nAGE = #{r.grade}\n"
      txt += "ID# = #{r.uscf_member_id}\nRATING = #{r.rating}\n" unless r.uscf_member_id.nil?
      txt += "\n"
    end
    txt
  end

end



