PawnParade::Application.routes.draw do

  resources :schedules, :only => [:show, :index]

  resources :tournaments, :only => [:show] do
    resources :registrations, :only => [:create, :new, :index]
  end

end
