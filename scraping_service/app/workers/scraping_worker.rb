class ScrapingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'scrapingworker'

  def perform(url, task_id, token, user_id)
    response = HTTParty.put(
      "http://task_management:3000/tasks/#{task_id}",
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      },
      body: {
        status: "1",
      }.to_json
    )

    sleep(300)

    data = scrap_service.scrape(url)

    price_str = data[:price] 
    price_decimal = price_str.gsub('R$', '').gsub('.', '').gsub(',', '.').strip.to_d
  
    ScrapedData.create!(task_id: task_id, brand: data[:brand], model: data[:model], price: price_decimal, user_id: user_id )

    response = HTTParty.put(
      "http://task_management:3000/tasks/#{task_id}",
      headers: {
        'Authorization' => "Bearer #{token}",
        'Content-Type' => 'application/json'
      },
      body: {
        status: "2",
      }.to_json
    )

    scrap_service.send_notification(token,task_id, user_id)
  end

  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
