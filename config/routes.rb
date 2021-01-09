Rails.application.routes.draw do
  namespace :v1 do
    # connection test route
    resource :ping, only: [:show]

    resources :schools, only: %i[create update destroy]

    # This was made to comply with the standardized url given in the exercise
    get 'recipient/:school_id', to: 'recipients#index'
    post 'recipient/:school_id', to: 'recipients#create'
    patch 'recipient/:school_id', to: 'recipients#update'
    delete 'recipient/:school_id', to: 'recipients#destroy'
    # Personally i would've go with something similar to:
    # resources :schools do
    #   resources :recipients, only: %i[index create update destroy]
    # end

  end
end
