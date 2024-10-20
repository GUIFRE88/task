require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do

  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user).and_return(true)
  end
  
  let(:valid_attributes) do
    {
      task_id: 1,
      user_id: 1,
      action: 'create',
      details: 'Notification details'
    }
  end

  let(:invalid_attributes) do
    {
      task_id: nil,
      user_id: nil,
      action: 'delete',
      details: ''
    }
  end

  describe 'POST #create' do
    let(:send_notification_service) { double('SendNotificationService') }

    before do
      allow(SendNotificationService).to receive(:new).and_return(send_notification_service)
    end

    context 'with valid params' do
      it 'creates a new notification' do
        expect(send_notification_service).to receive(:create_notification).with(valid_attributes).and_return(success: true, message: 'Notification created successfully')

        post :create, params: { notification: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Notification created successfully')
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable_entity status' do
        expect(send_notification_service).to receive(:create_notification).with(invalid_attributes).and_return(success: false, errors: { task_id: ["can't be blank"], user_id: ["can't be blank"] })

        post :create, params: { notification: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['task_id']).to include("can't be blank")
        expect(JSON.parse(response.body)['user_id']).to include("can't be blank")
      end
    end
  end

  describe 'GET #show' do
    let(:notification) { Notification.create!(valid_attributes) }

    context 'when notification exists' do
      it 'returns the notification' do
        get :show, params: { id: notification.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['task_id']).to eq(notification.task_id)
      end
    end

    context 'when notification does not exist' do
      it 'returns not found status' do
        get :show, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Notification not found')
      end
    end
  end
end
