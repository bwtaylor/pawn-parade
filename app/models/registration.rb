class Registration < ActiveRecord::Base

  attr_accessible :tournament_id,
                  :section,
                  :status,
                  :score,
                  :prize,
                  :team_prize,
                  :first_name,
                  :last_name,
                  :school,
                  :grade,
                  :guardian_emails,
                  :uscf_member_id,
                  :date_of_birth,
                  :address,
                  :city,
                  :state,
                  :zip_code,
                  :county,
                  :gender,
                  :rating,
                  :fee,
                  :paid,
                  :payment_method,
                  :payment_note


  belongs_to :tournament, :foreign_key => 'tournament_id' #, :class_name => 'Tournament'
  belongs_to :player

  validates :section, :length => { :maximum => 40 }
  validates :first_name, :presence => true, :length => { :maximum => 40 }
  validates :last_name, :presence => true, :length => { :maximum => 40 }
  validates :school, :presence => true, :length => { :maximum => 80 }
  validates :uscf_member_id, :allow_blank => true, format: { with: /^\d{8}$/, message: "id must be 8 digits" }

  GRADE_LIST = %w(K 1 2 3 4 5 6 7 8 9 10 11 12 99)
  GRADE_OPTIONS_FOR_SELECT= %w(K 1 2 3 4 5 6 7 8 9 10 11 12).map {|g| [g,g]} + [%w(Adult 99)]

  validates_inclusion_of :grade,  :in => Registration::GRADE_LIST
  validates_inclusion_of :gender, :in => %w(M F)
  validates_inclusion_of :payment_method, :allow_nil => true, :in => %w(cash check paypal)

  validates_inclusion_of :shirt_size, :allow_nil => true,
    :in => ['Youth Small (6-8)', 'Youth Medium (10-12)', 'Youth Large (14-16)', 'Adult Small', 'Adult Medium', 'Adult Large', 'Adult XL']

  STATUSES = [
      'request',                 # submitted through website, needing admin approval
      'waiting list',            # section is full
      'duplicate',               # automated or manually discarded as duplicate
      'preregistered',           # approved preregistration request, spot is held for player, may need to pay
      'uscf membership expired', # request for rated section, but USCF membership is expired: must renew by tny time or withdraw
      'uscf id needed',          # request for rated section, but no valid USCF member id provided: provide or withdraw
      'uscf problem',            # data provided to enable renewal/purchase of USCF membership has a problem
      'spam',                    # moderator discarded as junk
      'registered',              # paid, checked in, no USCF issues, will be paired
      'no show',                 # preregistered by has not check in by end of check in
      'withdraw'                 # voluntarily withdraw, before or after playing
  ]
  validates_inclusion_of :status, :allow_nil => true, :in =>  Registration::STATUSES

  after_initialize :guardians
  before_validation :school_for_adults
  validate :upcase, :section_status, :guardian_emails_format, :name_matches_player, :section_eligibility
  before_create :no_duplicates
  before_save :default_values

  def guardian_emails_format
    email_regex = /([a-z0-9][-a-z0-9_\+\.]*[a-z0-9])@([a-z0-9][-a-z0-9\.]*[a-z0-9]\.(arpa|root|aero|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw)|([0-9]{1,3}\.{3}[0-9]{1,3}))/
    first_bad = guardians.find {|it| email_regex =~ it ? false : true }
    errors.add(:guardian_emails, "Malformed email address: #{first_bad}") if first_bad
  end

  def school_for_adults
    self.school='N/A - Adult' if grade.eql?('99')
  end

  def grade_display
    grade.eql?('99') ? 'Adult' : grade
  end

  def guardians
    @guardians = self.guardian_emails.split /[\s,;:]+/ if @guardians.nil? && self.guardian_emails
    @guardians
  end

  def upcase
    self.first_name = self.first_name.strip.upcase
    self.last_name = self.last_name.strip.upcase
  end

  def section_status
    case self.status
    when 'withdraw', 'duplicate', 'spam'
        self.fee = 0.00
    when 'no show'
    else
      self.fee = self.tournament.fee
      self.fee ||= 0.00
      self.paid ||= 0.00
      errors.add(:section, 'Section can\'t be blank.') if self.section.nil? or self.section.empty?
    end
  end


  def uscf_player?
    p = self.player
    !p.nil? && !p.uscf_id.nil? && (p.uscf_id.length == 8)
  end

  def rated_section_rules

    self.status = 'uscf id needed' if self.uscf_member_id.nil? || self.uscf_member_id.empty?

    if !self.player.nil?
      if !uscf_player?
        dob_not_found = date_of_birth.nil?
        address_not_found = address.nil? || address.empty?
        city_not_found = city.nil? || city.empty?
        state_not_found  = state.nil? || state.empty?
        zip_code_not_found = zip_code.nil? || zip_code.empty?

        errors.add(:uscf_member_id, 'Rated Sections require either valid USCF ID or both date of birth and address') if
          dob_not_found || address_not_found || city_not_found || state_not_found || zip_code_not_found
      elsif self.player.uscf_status.eql?('EXPIRED')
        self.status = 'uscf membership expired'
      elsif self.status.eql?('uscf membership expired')
        self.status = 'request'
      end
    end
    self.status = 'waiting list' if get_section.full?
  end

  def name_matches_player
    if uscf_player?
      errors.add(:last_name, 'Last Name must match USCF') unless last_name.upcase.eql? player.last_name
      errors.add(:first, 'First Name must be similar to USCF') unless player.first_name.include?(first_name.upcase)
    end
  end

  def get_section
    Section.find_by_tournament_id_and_name(self.tournament.id, self.section)
  end

  def section_eligibility
    section = get_section
    rated_section_rules unless section.nil? || !section.rated? || ['withdraw','duplicate','spam'].include?(self.status)
    unless section.nil?
      grade = (self.grade == 'K') ? 0 : self.grade.to_i
      errors.add(:section, 'Grade Too High for Section') unless grade <= section.grade_max
      errors.add(:section, 'Grade Too Low for Section')  unless grade >= section.grade_min
      player_rating = 0
      if section.rated? && uscf_player?
        rating_type = section.tournament.rating_type
        if rating_type.eql?('regular')
          player_rating = self.player.uscf_rating_reg || 0
        elsif rating_type.eql?('regular-live')
          player_rating = self.player.uscf_rating_reg_live || self.player.pull_live_rating || 0
        end
        self.rating = (player_rating == 0 ? 'UNR' : player_rating)
        if player_rating >= (section.rating_cap ||= 9999)
          errors.add(:section, 'Rating Too High for Section')
        end
      end
    end
  end

  def no_duplicates
    # @todo: use guardian email address to improve fn/ln matcher
    t = tournament
    fn = first_name.strip
    ln = last_name.strip
    duplicate = Registration.find_by_uscf_member_id_and_tournament_id(self.uscf_member_id, t.id) if self.uscf_member_id
    duplicate ||= Registration.find_by_player_id_and_tournament_id(self.player_id, t.id) unless self.player_id.nil?
    duplicate ||= Registration.find_by_first_name_and_last_name_and_tournament_id(fn,ln,t.id)
    errors.add(:last_name, "#{ln},#{fn} is already registered for #{t.name}") unless duplicate.nil?
  end

  def default_values
    self.status ||= get_section.full? ? 'waiting list' : 'request'
    self.uscf_member_id = nil if self.uscf_member_id.blank?
  end

  def sync_from_player
    r=self
    p = r.player
    r.uscf_member_id = p.uscf_id unless p.uscf_id.nil? || p.uscf_id.empty?
    r.date_of_birth = p.date_of_birth unless p.uscf_id.nil? || p.uscf_id.empty?
    r.school = p.team.name unless p.team.nil?
    r.rating = p.rating(r)
    r.address = p.address unless p.address.nil? || p.address.empty?
    r.city = p.city unless p.city.nil? || p.city.empty?
    r.state = p.state unless p.state.nil? | p.state.empty?
    r.zip_code = p.zip_code unless p.zip_code.nil? || p.zip_code.empty?
    section = get_section
    rated_section_rules if !section.nil? and section.rated?
    r.status = 'request' if r.status.eql?('uscf id needed') && !r.uscf_member_id.nil? && r.uscf_member_id.length == 8
    r.save
  end

  def associate_player
    r = self
    r.valid?
    player = Player.find_by_uscf_id(r.uscf_member_id) unless r.uscf_member_id.nil? or r.uscf_member_id.empty?
    player = Player.find_by_first_name_and_last_name_and_grade(r.first_name, r.last_name, r.grade) if player.nil?
    player = Player.new(
        :first_name => r.first_name,
        :last_name => r.last_name,
        :uscf_id => r.uscf_member_id,
        :school => r.school,
        :grade => r.grade,
        :date_of_birth => r.date_of_birth,
        :gender => r.gender,
        :address => r.address,
        :city => r.city,
        :state => r.state,
        :zip_code => r.zip_code,
        :county => r.county
    ) if player.nil?
    r.player = player
  end

  def team_slug
    r=self
    p=r.player
    if p.team.nil?

    else
      p.team.slug
    end
  end

end
