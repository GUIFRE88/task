require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) { Notification.new(task_id: 1, user_id: 1, action: "create", details: "Detalhes da notificação") }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(notification).to be_valid
    end

    it 'is not valid without a task_id' do
      notification.task_id = nil
      expect(notification).to_not be_valid
      expect(notification.errors[:task_id]).to include("can't be blank")
    end

    it 'is not valid without a user_id' do
      notification.user_id = nil
      expect(notification).to_not be_valid
      expect(notification.errors[:user_id]).to include("can't be blank")
    end

    it 'is not valid without an action' do
      notification.action = nil
      expect(notification).to_not be_valid
      expect(notification.errors[:action]).to include("can't be blank")
    end

    it 'is not valid with an invalid action' do
      notification.action = 'delete'
      expect(notification).to_not be_valid
      expect(notification.errors[:action]).to include("delete is not a valid action")
    end

    it 'is valid with a valid action' do
      notification.action = 'create'
      expect(notification).to be_valid

      notification.action = 'update'
      expect(notification).to be_valid
    end
  end

end
