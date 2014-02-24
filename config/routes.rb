PawnParade::Application.routes.draw do

  resources :players, :only => [:create, :new, :index, :show, :edit]

  get "dashboard/index", :as => 'user_root'

  resources :teams do
    member do
      post 'create_player'
      get 'create_player'
      post 'search'
    end
  end

  devise_for :users

  root :to => 'home#index'

  resources :schedules, :only => [:show, :index]

  resources :tournaments, :only => [:show] do
    resources :registrations, :only => [:create, :new, :index]
  end

end
