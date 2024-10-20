require 'rails_helper'

RSpec.describe ScrapingController, type: :controller do

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
  end

  describe 'POST #start_scraping' do
    let(:valid_attributes) do
      {
        task_id: 1,
        url: 'http://example.com',
        user_id: 1
      }
    end

    context 'with missing params' do
      it 'returns an error when task_id is missing' do
        post :start_scraping, params: valid_attributes.except(:task_id)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Task ID, USER_ID and URL are required.")
      end

      it 'returns an error when url is missing' do
        post :start_scraping, params: valid_attributes.except(:url)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Task ID, USER_ID and URL are required.")
      end

      it 'returns an error when user_id is missing' do
        post :start_scraping, params: valid_attributes.except(:user_id)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("error" => "Task ID, USER_ID and URL are required.")
      end
    end

    context 'when an error occurs' do
      before do
        allow(ScrapingWorker).to receive(:perform_async).and_raise(StandardError.new("Scraping failed"))
      end

      it 'returns an internal server error' do
        post :start_scraping, params: valid_attributes
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)).to include("error" => "Scraping failed: Scraping failed")
      end
    end
  end

  describe 'GET #index' do
    let(:task_id) { 1 }

    before do
      @scraped_data = ScrapedData.create(task_id: task_id, brand: "FIAT", model: "MOBI", user_id: 1)
    end

    it 'returns a list of scraped data for the given task_id' do
      get :index, params: { task_id: task_id }
      expect(response).to have_http_status(:ok)
    end
  end
end
