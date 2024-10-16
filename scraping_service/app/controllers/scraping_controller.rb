class ScrapingController < ApplicationController
  def start_scraping
    task_id = params[:task_id]
    url = params[:url]

    if task_id.blank? || url.blank?
      render json: { error: "Task ID and URL are required." }, status: :unprocessable_entity
      return
    end

    begin
      scraped_data = scrap_service.scrape(url)
    rescue StandardError => e
      render json: { error: "Scraping failed: #{e.message}" }, status: :internal_server_error
      return
    end

    render json: { message: "Scraping task completed", task_id: task_id, data: scraped_data }, status: :ok
  end

  private
  
  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
