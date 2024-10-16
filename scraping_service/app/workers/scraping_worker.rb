# app/workers/scraping_worker.rb
class ScrapingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'scrapingworker'

  def perform(url, task_id, token)
    #sleep(300)

    data = scrap_service.scrape(url)

    price_str = data[:price] 
    price_decimal = price_str.gsub('R$', '').gsub('.', '').gsub(',', '.').strip.to_d
  

    ScrapedData.create!(task_id: task_id, brand: data[:brand], model: data[:model], price: price_decimal )


    #response = HTTParty.post(
    #  "#{ENV['NOTIFICATION_SERVICE_URL']}/notifications",
    #  headers: {
    #    'Authorization' => "Bearer #{token}",
    #    'Content-Type' => 'application/json'
    #  },
    #  body: {
    #    task_id: task_id,
    #    user_id: 1,
    #    action: "create",
    #    details: "Scraping was completed successfully."
   #   }.to_json
   # )

    # Processar os dados conforme necessário
    puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa'
    puts "Dados extraídos: #{data}"
  end

  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
