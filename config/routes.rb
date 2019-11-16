Rails.application.routes.draw do
  defaults format: :json do
    get '/me', to: 'auth#me'
    resources :ideas, only: [:index, :show, :create, :update, :destroy]
    resources :users, only: [:create]
    scope 'access-tokens' do
      post '/', to: 'access_tokens#create'
      delete '/', to: 'access_tokens#destroy'
      post '/refresh', to: 'access_tokens#refresh'
    end
  end
end
