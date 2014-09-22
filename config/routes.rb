PawnParade::Application.routes.draw do

  if Rails.env.production?

    match '*path' => redirect { | params, req | "https://www.rackspacechess.com/#{params[:path]}" },
      :constraints => { :protocol => 'http://' }

    match '*path' => redirect { | params, req | "https://www.rackspacechess.com/#{params[:path]}" },
      :constraints => { :subdomain => '' }

  else

    match '*path' => redirect { | params, req | "http://www.devchess.com:3000/#{params[:path]}" },
      :constraints => { :subdomain => '' }

  end


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
      post 'freshen_uscf'
    end
  end

  devise_for :users

  root :to => 'home#index'

  resources :schedules, :only => [:show, :index]

  resources :tournaments, :only => [:show] do
    get 'guardian_show', on: :member
    get 'uscf', on: :member
    resources :registrations, :only => [:create, :new, :index]
    resources :sections, :only => [:index, :show, :edit, :update]
  end

end
