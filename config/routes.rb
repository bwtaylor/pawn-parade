PawnParade::Application.routes.draw do

  devise_for :users

  root :to => 'home#index'

  resources :schedules, :only => [:show, :index]

  resources :tournaments, :only => [:show] do
    resources :registrations, :only => [:create, :new, :index]
  end

end
