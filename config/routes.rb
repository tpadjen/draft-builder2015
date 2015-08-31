Rails.application.routes.draw do
  resources :leagues, path: '/l' do
    post 'pick/undo' => 'draft_picks#undo'
    post 'pick' => 'draft_picks#pick', :defaults => { :format => 'json' }

    get 'boards/draft' => 'boards#draft', as: :draft_board
    get 'boards/adp_ffc' => 'boards#adp_ffc', as: :ffc_board
    get 'boards/adp_espn' => 'boards#adp_espn', as: :espn_board
    get 'boards/points' => 'boards#points', as: :points_board

    get 'teams/edit' => 'leagues_view#edit_teams', as: :teams_edit
    # post 'teams/update' => 'leagues_view#update_teams', as: :teams_update
    patch 'teams/update' => 'leagues_view#update_teams', as: :teams_update
    get 'team/:owner' => 'fantasy_teams#show', as: :team
    get 'pos/:position' => 'positions#index', as: :positions
    get 'pos' => 'positions#index', as: :all_positions
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'leagues#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
