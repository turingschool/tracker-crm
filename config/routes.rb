Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index, :show, :update] do

        resources :job_applications, only: [:create, :index, :show, :update, :destroy] do
          get 'interview_questions', to: 'interview_questions#show'
        end

        resources :companies, only: [:create, :index, :update, :destroy] do
          resources :contacts, only: [:create, :index]
        end

        resources :contacts, only: [:index, :create, :show, :destroy, :update]
        resource :dashboard, only: :show
      end

      resources :sessions, only: :create
      resources :interview_questions, only: [:index]
      # post 'interview_questions', to: 'interview_questions#index'
    end
  end
end