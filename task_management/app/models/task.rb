class Task < ApplicationRecord
  validates :url, presence: true
  validates :status, presence: true
  validates :task_type, presence: true
end
