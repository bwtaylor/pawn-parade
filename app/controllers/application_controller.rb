class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do |controller|
    @hostname = request.host
  end

  def authorize_admin
    target = request.referer || user_root_url if current_user || root_url
    unless current_user && current_user.admin?
      flash[:notice] = 'You are not authorized to view the resource you requested'
      redirect_to target
    end
  end

end
