Rails.application.routes.draw do
  defaults format: :json do
    resources :ideas, only: [:index, :show, :create, :update]
  end
end
