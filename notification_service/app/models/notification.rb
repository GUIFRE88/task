class Notification < ApplicationRecord
  validates :task_id, :user_id, :action, presence: true
  validates :action, inclusion: { in: %w[create update], message: "%{value} is not a valid action" }


  def send_notification
    NotificationService.new.send(
      user: user,
      task: task,
      action: action,
      details: details
    )

    update(notification_sent_at: Time.current)
  end
end
