class ScrapingController < ApplicationController
  def start_scraping
    token = request.headers['Authorization']&.split(' ')&.last
    task_id = params[:task_id]
    url = params[:url]

    if task_id.blank? || url.blank?
      render json: { error: "Task ID and URL are required." }, status: :unprocessable_entity
      return
    end

    begin
      ScrapingWorker.perform_async(url, task_id, token)
      #scraped_data = scrap_service.scrape(url)
    rescue StandardError => e
      render json: { error: "Scraping failed: #{e.message}" }, status: :internal_server_error
      return
    end

    render json: { message: "Scraping task completed", task_id: task_id }, status: :ok
  end

  private
  
  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
