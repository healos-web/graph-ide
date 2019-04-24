Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :graphs, extend: %i[new edit] do
    resources :nodes, :arcs, shallow: true, only: %i[update]
    resources :nodes, :arcs, only: :create
    collection do
      get :get_graphs
      post :calcul_cartesian_product
      post :calcul_vector_product
      get :autocomplete
      get :open
      get :close
    end
    member do
      post :clipboard_data
      post :copy_to_clipboard
      post :find_hamiltonyan_cycles
      post :to_full
      post :update_elements
      post :selected_elements
      post :delete_elements
    end
  end
end
