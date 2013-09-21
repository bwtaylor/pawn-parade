class SchedulesController < ApplicationController
  
  def show
    @schedule = Schedule.find_by_name(params[:id])
  end
  
end
