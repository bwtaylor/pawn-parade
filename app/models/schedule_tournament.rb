class ScheduleTournament < ActiveRecord::Base
  attr_accessible :schedule_id, :tournament_id
  belongs_to :schedule
  belongs_to :tournament
end
