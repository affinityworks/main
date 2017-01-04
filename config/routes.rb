Rails.application.routes.draw do
  devise_for :people
  resources :groups
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resource :person
    end
  end

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/queries"
  root to: redirect("/graphiql")
  resources :queries
  resource :sha, only: :show
end
