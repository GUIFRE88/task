class ScrapedData < ApplicationRecord
  validates :task_id, :brand, :model, :user_id, presence: true
end
