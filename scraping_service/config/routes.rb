require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  post '/start_scraping', to: 'scraping#start_scraping'
end
