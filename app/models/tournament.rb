class Tournament < ActiveRecord::Base

  attr_accessible :slug, :name, :location, :event_date, :short_description

  def to_param
    slug
  end
end

