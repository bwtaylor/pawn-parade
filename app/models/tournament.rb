class Tournament < ActiveRecord::Base
  attr_accessible :slug, :location, :event_date
end
