class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do |controller|
    @hostname = request.host
  end

  def authorize_admin
    redirect_to request.referer unless current_user && current_user.admin?
  end

end
