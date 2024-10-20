class ScrapingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'scrapingworker'

  def perform(url, task_id, token, user_id)

    scrap_service.update_task(token, task_id, "1")

    sleep(300)

    data = scrap_service.scrape(url)
    price_str = data[:price] 
    price_decimal = price_str.gsub('R$', '').gsub('.', '').gsub(',', '.').strip.to_d
  
    ScrapedData.create!(task_id: task_id, brand: data[:brand], model: data[:model], price: price_decimal, user_id: user_id )

    scrap_service.update_task(token, task_id, "2")
    scrap_service.send_notification(token,task_id, user_id)

    true
  end

  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
