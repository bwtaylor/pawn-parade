class SchedulesController < ApplicationController
  
  def show
    @schedule = Schedule.find_by_slug(params[:id])
  end

  def index
    @schedules = Schedule.all
  end
  
end
