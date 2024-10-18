require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  post '/start_scraping', to: 'scraping#start_scraping'
  get '/scraping/:task_id', to: 'scraping#show', as: 'scraping_show'

end
