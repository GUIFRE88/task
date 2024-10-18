class ScrapingController < ApplicationController
  def start_scraping
    token = request.headers['Authorization']&.split(' ')&.last
    task_id = params[:task_id]
    url = params[:url]
    user_id = params[:user_id]

    if task_id.blank? || url.blank? || user_id.blank?
      render json: { error: "Task ID, USER_ID and URL are required." }, status: :unprocessable_entity
      return
    end

    begin
      ScrapingWorker.perform_async(url, task_id, token, user_id)
    rescue StandardError => e
      render json: { error: "Scraping failed: #{e.message}" }, status: :internal_server_error
      return
    end

    render json: { message: "Scraping task completed", task_id: task_id }, status: :ok
  end

  def index
    @scraping = ScrapedData.where(task_id: params[:task_id])

    render json: @scraping
  end

  private
  
  def scrap_service
    @scrap_service ||= ScrapService.new
  end
end
