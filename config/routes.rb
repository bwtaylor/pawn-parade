PawnParade::Application.routes.draw do

  resources :schedules, :only => [:show, :index]
  resources :tournaments, :only => [:show]

end
