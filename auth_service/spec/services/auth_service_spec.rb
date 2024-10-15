# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthUserService, type: :service do
  let(:user_params) do
    {
      email: Faker::Internet.email,
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  let(:invalid_user_params) do
    {
      email: Faker::Internet.email,
      password: 'password123',
      password_confirmation: 'wrong_password'
    }
  end

  let(:auth_user_service) { AuthUserService.new }

  describe '#signup' do
    context 'with valid parameters' do
      it 'creates a new user' do
        result = auth_user_service.signup(user_params)
        expect(User.find_by(email: user_params[:email])).to be_present
        expect(result[:success]).to be(true)
        expect(result[:message]).to eq('User created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns errors' do
        result = auth_user_service.signup(invalid_user_params)
        expect(User.find_by(email: invalid_user_params[:email])).to be_nil
        expect(result[:success]).to be(false)
        expect(result[:errors]).to include("Password confirmation doesn't match Password")
      end
    end
  end

  describe '#login' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'returns a token' do
        result = auth_user_service.login(user.email, 'password123')
        expect(result[:success]).to be(true)
        expect(result[:token]).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        result = auth_user_service.login(user.email, 'wrong_password')
        expect(result[:success]).to be(false)
        expect(result[:error]).to eq('Invalid email or password')
      end
    end
  end

  describe '#validate_token' do
    let(:user) { create(:user) }
    let(:token) { auth_user_service.send(:jwt_encode, user_id: user.id) }

    context 'with valid token' do
      it 'validates the token' do
        result = auth_user_service.validate_token(token)
        expect(result[:valid]).to be(true)
        expect(result[:message]).to eq('Token is valid')
      end
    end

    context 'with invalid token' do
      it 'returns an error' do
        invalid_token = 'invalid_token'
        result = auth_user_service.validate_token(invalid_token)
        expect(result[:valid]).to be(false)
        expect(result[:error]).to eq('Invalid token')
      end
    end
  end
end
