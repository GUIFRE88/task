require 'rails_helper'

RSpec.describe Task, type: :model do
  subject { Task.new(url: url, status: status, task_type: task_type) }

  let(:url) { "http://example.com" }
  let(:status) { "pending" }
  let(:task_type) { "scraping" }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a url' do
      subject.url = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:url]).to include("can't be blank")
    end

    it 'is not valid without a status' do
      subject.status = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:status]).to include("can't be blank")
    end

    it 'is not valid without a task_type' do
      subject.task_type = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:task_type]).to include("can't be blank")
    end
  end
end
