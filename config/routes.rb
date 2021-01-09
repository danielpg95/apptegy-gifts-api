Rails.application.routes.draw do
  namespace :v1 do
    # connection test route
    resource :ping, only: [:show]
    resources :schools, only: %i[index create update destroy]
  end
end
