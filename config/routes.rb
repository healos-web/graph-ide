Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :graphs, extend: %i[new edit] do
    resources :nodes, :arcs, shallow: true, only: :update
    resources :nodes, :arcs, only: :create
    collection do
      get :autocomplete
      get :open
      get :close
    end
    member do
      post :delete_elements
    end
  end
end
