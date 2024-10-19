class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show]

  # POST /notifications
  def create
    @notification = Notification.new(notification_params)

    if @notification.save

      ActionCable.server.broadcast("notifications_#{notification_params[:user_id]}", { message: "Finished scraping task #{notification_params[:task_id]}" })
      
      render json: { message: 'Notification sent successfully' }, status: :created
    else
      render json: @notification.errors, status: :unprocessable_entity
    end
  end

  # GET /notifications/:id
  def show
    render json: @notification
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Notification not found' }, status: :not_found
  end

  def notification_params
    params.require(:notification).permit(:task_id, :user_id, :action, :details)
  end
end
