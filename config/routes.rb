require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users, skip:[:registrations]
  namespace :api, defaults: {format: :json}, path: '/'  do
    scope module: :v1 , constraints: ApiConstraints.new(version: 1, default: true) do
      root 'main#home'
      resources :users, only: [:show,:create,:update,:destroy]
      resources :sessions, only: [:create, :destroy]
      resources :universities, only: [:create,:update,:destroy]
      resources :universities, only: [:index,:show] do
        resources :carreers, only: [:index]
        resources :campus, only: [:index]
      end
      resources :carreers, only: [:index, :show,:create,:update,:destroy]
      resources :cities, only: [:show,:index] do
        resources :universities, only: [:index]
        resources :campus, only: [:index]
      end
      resources :campus, only: [:index,:show,:create,:update, :destroy]
      resources :goals, only: [:index,:create,:update,:show,:destroy]
      resources :search, only: [:index]
      resources :regions, only: [:show,:index] do
        resources :cities, only: [:index]
      end
      resources :areas, only: [:index,:show]
      resources :university_types, only:[:index]
      resources :subjects, only:[:index]
      resources :essays, only:[:index,:create,:destroy]
      resources :progress, only: [:index]
      resources :objectives, on: [:index,:create]
      resources :news, only: [:index,:show,:create, :update,:destroy]
      resources :reset_passwords, only: [:index]
      resources :prediction, only: [:index,:show]
      resources :recommendation, only: [:index,:create,:update]
      get 'recommendation/liked', to: 'recommendation#liked'
      resources :similar, only: [:index]

      get '/progress/:goal_id', to:'progress#show'
      get '/popular/universities', to: 'main#popular_universities'
      get '/popular/carreers', to: 'main#popular_carreers'
      get '/schedules', to: 'main#schedules', via: :all
      get '/validate_rut', to: 'main#validate_rut', via: :all
      get '*path', to: 'errors#error_404', via: :all
    end

  end
end
