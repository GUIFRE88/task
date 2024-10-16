Rails.application.routes.draw do
  post '/start_scraping', to: 'scraping#start_scraping'
end
