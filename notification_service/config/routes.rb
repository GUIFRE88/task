Rails.application.routes.draw do
  resources :notifications, only: [:create, :show]
  mount ActionCable.server => '/cable'
end
