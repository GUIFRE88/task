require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ScrapService do
  let(:service) { ScrapService.new }

  describe '#scrape' do
    it 'returns brand, model, and price from the webpage' do
      allow(Puppeteer).to receive(:launch).and_yield(double(new_page: double(
        set_user_agent: nil,
        goto: nil,
        content: '<html><body><h1 id="VehicleBasicInformationTitle">FIAT MOBI</h1><div id="vehicleSendProposalPrice">R$ 45.000,00</div></body></html>',
        status: 200,
        title: 'Test Page Title'
      )))

      result = service.scrape('http://example.com')

      expect(result).to eq({
        brand: 'FIAT',
        model: 'M',
        price: 'R$ 45.000,00'
      })
    end

    it 'raises an error when the page title includes "Error"' do
      allow(Puppeteer).to receive(:launch).and_yield(double(new_page: double(
        set_user_agent: nil,
        goto: nil,
        content: '<html><body><h1>Error</h1></body></html>',
        status: 404,
        title: 'Error'
      )))

      expect { service.scrape('http://example.com') }.to raise_error(RuntimeError, "Failed to retrieve the webpage. Status code: 404")
    end
  end

  describe '#send_notification' do
    it 'makes a POST request to the notification service' do
      token = 'test_token'
      task_id = 1
      user_id = 1

      stub_request(:post, "http://notification_service:3000/notifications")
        .with(
          headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
          body: {
            task_id: task_id,
            user_id: user_id,
            action: "create",
            details: "Scraping was completed successfully."
          }.to_json
        )
        .to_return(status: 200)

      response = service.send_notification(token, task_id, user_id)

      expect(response.code).to eq(200)
    end
  end

  describe '#update_task' do
    it 'makes a PUT request to update the task status' do
      token = 'test_token'
      task_id = 1
      status = 'completed'

      stub_request(:put, "http://task_management:3000/tasks/#{task_id}")
        .with(
          headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
          body: { status: status }.to_json
        )
        .to_return(status: 200)

      response = service.update_task(token, task_id, status)

      expect(response.code).to eq(200)
    end
  end
end
