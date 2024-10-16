Rails.application.routes.draw do
  resources :notifications, only: [:create, :show]
end
