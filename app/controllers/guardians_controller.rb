class PlayersController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html

end