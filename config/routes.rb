PawnParade::Application.routes.draw do

  resources :schedules, :only => [:show]
  resources :tournaments, :only => [:show]

end
