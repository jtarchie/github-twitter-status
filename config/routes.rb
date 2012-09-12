GithubStatus::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#create', as: "omniauth_callback"

  resource :dashboard, controller: "dashboard"
  root to: "dashboard#show"
end
