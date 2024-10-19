
# frozen_string_literal: true
class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show]

  # POST /notifications
  def create
    result = send_notification_service.create_notification(notification_params)

    if result[:success]
      render json: { message: result[:message] }, status: :created
    else
      render json: result[:errors], status: :unprocessable_entity
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

  def send_notification_service
    @send_notification_service ||= SendNotificationService.new
  end
end
