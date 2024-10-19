# frozen_string_literal: true

class SendNotificationService
  def create_notification(notification_params)
    notification = Notification.new(notification_params)

    if notification.save
      broadcast_notification(notification)
      { success: true, message: 'Notification sent successfully' }
    else
      { success: false, errors: notification.errors }
    end
  end

  private

  def broadcast_notification(notification)
    ActionCable.server.broadcast("notifications_#{notification.user_id}", {
      message: "Finished scraping task #{notification.task_id}"
    })
  end
end
