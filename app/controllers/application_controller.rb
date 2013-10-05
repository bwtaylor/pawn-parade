class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do |controller|
    @hostname = request.host
  end

end
