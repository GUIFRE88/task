# app/workers/scraping_worker.rb
class ScrapingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'scrapingworker'

  def perform(url, task_id, token)
    sleep(300)

    data = scrap_service.scrape(url)

    price_str = data[:price] 
    price_decimal = price_str.gsub('R$', '').gsub('.', '').gsub(',', '.').strip.to_d
  
    ScrapedData.create!(task_id: task_id, brand: data[:brand], model: data[:model], price: price_decimal )

    scrap_service.send_notification(token,task_id)
  end

  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
