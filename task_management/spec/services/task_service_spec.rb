require 'rails_helper'
require 'httparty'
require 'webmock/rspec'

RSpec.describe TaskService do
  let(:valid_task) { Task.new(id: 1, user_id: 1, url: "http://example.com", task_type: '0') }
  let(:invalid_task) { Task.new(id: 2, user_id: 2, url: "http://example.com", task_type: '1') }
  let(:token) { "valid_token" }

  subject { TaskService.new }

  describe '#start_scraping' do
    context 'when task type is scraping' do
      before do
        stub_request(:post, "http://scraping_service:3000/start_scraping")
          .with(
            headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' },
            body: {
              task_id: valid_task.id,
              user_id: valid_task.user_id,
              url: valid_task.url
            }.to_json
          )
          .to_return(status: 200, body: "", headers: {})
      end

      it 'initiates scraping successfully' do
        expect { subject.start_scraping(valid_task, token) }.to output(/Scraping iniciado com sucesso para a tarefa 1/).to_stdout
      end
    end

    context 'when task type is not scraping' do
      it 'does not initiate scraping' do
        expect { subject.start_scraping(invalid_task, token) }.not_to output(/Scraping iniciado com sucesso/).to_stdout
      end
    end
  end
end
