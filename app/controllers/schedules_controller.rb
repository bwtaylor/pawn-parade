class SchedulesController < ApplicationController
  
  def show
    @schedule = Schedule.find_by_name(params[:id])
    
#   @schedule = Schedule.create!( :name => "testschedule")
#   
#   tournaments = [ ["London" , "2013-1-20"],
#                   ["Las Vegas", "2013-6-2"],
#                   ["Rackspace", "2013-10-26"] ]
#   
#   tournaments.each  do |tournament|
#     @schedule.tournaments << Tournament.create!(
#       :location => tournament[0],
#       :event_date => Date::strptime(tournament[1], "%Y-%m-%d")
#     )
#   end

  end
  
end
