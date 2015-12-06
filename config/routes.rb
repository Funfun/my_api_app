require 'api_constraints'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: 'json'} do
    scope module: 'v1', constraints: ApiConstraints.new(version: 1)  do
      resources :users
      resources :epics do
        resources :stories
      end
      resources :sessions, only: [:create]
    end
  end
end
