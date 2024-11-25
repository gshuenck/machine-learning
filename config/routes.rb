Rails.application.routes.draw do
  resources :chat_messages
  resources :trainings
  get "up" => "rails/health#show", as: :rails_health_check
  root "pages#home"
end
