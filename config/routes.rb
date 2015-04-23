Refinery::Core::Engine.routes.draw do
  get '/system/videos/*dragonfly', :to => Dragonfly.app(:refinery_videos)

  # Frontend routes
  namespace :videos do
    resources :videos, :path => '', :only => [:index, :show]
    put 'increase_looked/:id' => 'videos#increase_looked'
  end

  # Admin routes
  namespace :videos, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :videos do
        post :append_to_wym
        collection do
          post :update_positions
          get :insert
          get :dialog_preview
        end
      end
      resources :categories, :except => :show do
        collection do
          post :update_positions
        end
      end
      resources :video_files, :only => [:destroy]
    end
  end

end
