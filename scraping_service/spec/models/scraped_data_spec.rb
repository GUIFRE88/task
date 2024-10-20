require 'rails_helper'

RSpec.describe ScrapedData, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      scraped_data = ScrapedData.new(task_id: 1, brand: "FIAT", model: "MOBI", user_id: 1)
      expect(scraped_data).to be_valid
    end

    it 'is not valid without a task_id' do
      scraped_data = ScrapedData.new(task_id: nil, brand: "FIAT", model: "MOBI", user_id: 1)
      expect(scraped_data).to_not be_valid
      expect(scraped_data.errors[:task_id]).to include("can't be blank")
    end

    it 'is not valid without a brand' do
      scraped_data = ScrapedData.new(task_id: 1, brand: nil, model: "MOBI", user_id: 1)
      expect(scraped_data).to_not be_valid
      expect(scraped_data.errors[:brand]).to include("can't be blank")
    end

    it 'is not valid without a model' do
      scraped_data = ScrapedData.new(task_id: 1, brand: "FIAT", model: nil, user_id: 1)
      expect(scraped_data).to_not be_valid
      expect(scraped_data.errors[:model]).to include("can't be blank")
    end

    it 'is not valid without a user_id' do
      scraped_data = ScrapedData.new(task_id: 1, brand: "FIAT", model: "MOBI", user_id: nil)
      expect(scraped_data).to_not be_valid
      expect(scraped_data.errors[:user_id]).to include("can't be blank")
    end
  end
end
