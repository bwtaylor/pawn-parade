PawnParade::Application.routes.draw do

  get "dashboard/index", :as => 'user_root'

  resources :teams do
    member do
      post 'create_player'
    end
  end

  devise_for :users

  root :to => 'home#index'

  resources :schedules, :only => [:show, :index]

  resources :tournaments, :only => [:show] do
    resources :registrations, :only => [:create, :new, :index]
  end

end
