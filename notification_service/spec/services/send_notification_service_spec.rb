require 'rails_helper'

RSpec.describe SendNotificationService do
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
      action: 'invalid_action',
      details: ''
    }
  end

  subject { described_class.new }

  describe '#create_notification' do
    context 'with valid attributes' do
      it 'creates a notification and broadcasts it' do
        notification = instance_double(Notification, save: true)
        allow(Notification).to receive(:new).with(valid_attributes).and_return(notification)
        allow(subject).to receive(:broadcast_notification)

        result = subject.create_notification(valid_attributes)

        expect(result).to eq({ success: true, message: 'Notification sent successfully' })
        expect(notification).to have_received(:save)
        expect(subject).to have_received(:broadcast_notification).with(notification)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a notification and returns errors' do
        notification = instance_double(Notification, save: false, errors: { task_id: ["can't be blank"] })
        allow(Notification).to receive(:new).with(invalid_attributes).and_return(notification)

        result = subject.create_notification(invalid_attributes)

        expect(result).to eq({ success: false, errors: notification.errors })
        expect(notification).to have_received(:save)
      end
    end
  end
end
