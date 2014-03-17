PawnParade::Application.routes.draw do

  resources :players, :only => [:create, :new, :index, :show, :edit, :update] do
    member do
      post 'register'
    end
    resources :tournaments do
      post 'section', to: 'registrations#change_section'
    end
  end
  post '/players/:id', to: 'players#show', as: :player_register

  get 'dashboard/index', :as => 'user_root'

  resources :teams, :only => [:create, :new, :index, :show, :edit, :update] do
    resources :tournaments, :only => [:show], :to => 'tournaments#team_show'
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
    get 'guardian_show', on: :member
    resources :registrations, :only => [:create, :new, :index]
    resources :sections, :only => [:index, :show, :edit, :update]
  end

end
