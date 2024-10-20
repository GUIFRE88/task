require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:valid_attributes) { { url: "http://example.com", status: "pending", task_type: "scraping" } }
  let(:invalid_attributes) { { url: nil, status: nil, task_type: nil } }
  
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
  end

  before(:each) do
    @task = Task.create(valid_attributes)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: @task.id }
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include("id" => @task.id, "url" => "http://example.com", "status" => "pending", "task_type" => "scraping")
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Task' do
        expect {
          post :create, params: { task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        post :create, params: { task: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include("url" => "http://example.com", "status" => "pending")
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the new task' do
        post :create, params: { task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("url" => ["can't be blank"], "status" => ["can't be blank"], "task_type" => ["can't be blank"])
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      it 'updates the requested task' do
        patch :update, params: { id: @task.id, task: { status: "completed" } }
        @task.reload
        expect(@task.status).to eq("completed")
      end

      it 'renders a JSON response with the task' do
        patch :update, params: { id: @task.id, task: { status: "completed" } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("url" => "http://example.com", "status" => "completed")
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the task' do
        patch :update, params: { id: @task.id, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("url" => ["can't be blank"], "status" => ["can't be blank"], "task_type" => ["can't be blank"])
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      expect {
        delete :destroy, params: { id: @task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'returns a no content response' do
      delete :destroy, params: { id: @task.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
