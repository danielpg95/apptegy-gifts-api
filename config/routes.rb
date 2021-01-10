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
    # Personally I would've go with something similar to:
    # resources :schools do
    #   resources :recipients, only: %i[index create update destroy]
    # end

    get 'order/:school_id', to: 'orders#index'
    post 'order/:school_id', to: 'orders#create'
    patch 'order/:school_id', to: 'orders#update'
    delete 'order/:school_id', to: 'orders#destroy'

    post 'ship_order/:school_id', to: 'orders#ship_order'
  end
end
