require 'rails_helper'

RSpec.describe AuthUserRepository, type: :repository do
  let(:auth_user_repository) { described_class.new }

  describe '#signup' do
    context 'when valid user params are provided' do
      let(:user_params) { attributes_for(:user) }

      it 'creates a new user and returns success message' do
        result = auth_user_repository.signup(user_params)

        expect(result[:success]).to be(true)
        expect(result[:message]).to eq('User created successfully')
        expect(User.find_by(email: user_params[:email])).not_to be_nil
      end
    end

    context 'when invalid user params are provided' do
      let(:user_params) { attributes_for(:user, email: '') }

      it 'returns error messages' do
        result = auth_user_repository.signup(user_params)

        expect(result[:success]).to be(false)
        expect(result[:errors]).to include("Email can't be blank")
      end
    end
  end

  describe '#create' do
    let(:user_params) { attributes_for(:user) }

    it 'creates a user and persists it to the database' do
      user = auth_user_repository.create(user_params)
      expect(User.find_by(email: user_params[:email])).to eq(user)
    end
  end

  describe '#find_by_email' do
    let!(:user) { create(:user, email: 'test@example.com') }

    it 'returns the user when email exists' do
      found_user = auth_user_repository.find_by_email('test@example.com')
      expect(found_user).to eq(user)
    end

    it 'returns nil when email does not exist' do
      found_user = auth_user_repository.find_by_email('nonexistent@example.com')
      expect(found_user).to be_nil
    end
  end

  describe '#exists?' do
    let!(:user) { create(:user) }

    it 'returns true if the user exists' do
      expect(auth_user_repository.exists?(user.id)).to be(true)
    end

    it 'returns false if the user does not exist' do
      expect(auth_user_repository.exists?(0)).to be(false)
    end
  end
end
