class ScrapedData < ApplicationRecord
  validates :task_id, :brand, :model, presence: true
end
