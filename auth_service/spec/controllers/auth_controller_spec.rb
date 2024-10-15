require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:auth_user_service) { instance_double(AuthUserService) }

  before do
    allow(controller).to receive(:auth_user_service).and_return(auth_user_service)
  end

  describe 'POST #login' do
    context 'when login is successful' do
      let(:login_params) { { email: 'test@example.com', password: 'password123' } }

      it 'returns a token' do
        allow(auth_user_service).to receive(:login).with('test@example.com', 'password123').and_return({ success: true, token: 'fake-jwt-token' })

        post :login, params: login_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['token']).to eq('fake-jwt-token')
      end
    end

    context 'when login fails' do
      let(:login_params) { { email: 'test@example.com', password: 'wrongpassword' } }

      it 'returns an unauthorized error' do
        allow(auth_user_service).to receive(:login).with('test@example.com', 'wrongpassword').and_return({ success: false, error: 'Invalid email or password' })

        post :login, params: login_params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'GET #validate' do
    context 'when token is valid' do
      let(:token) { 'valid-jwt-token' }

      it 'returns a success message' do
        allow(auth_user_service).to receive(:validate_token).with(token).and_return({ valid: true, message: 'Token is valid' })

        request.headers['Authorization'] = "Bearer #{token}"
        get :validate

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Token is valid')
      end
    end

    context 'when token is invalid' do
      let(:token) { 'invalid-jwt-token' }

      it 'returns an unauthorized error' do
        allow(auth_user_service).to receive(:validate_token).with(token).and_return({ valid: false, error: 'Invalid token' })

        request.headers['Authorization'] = "Bearer #{token}"
        get :validate

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid token')
      end
    end

    context 'when token is not provided' do
      it 'returns a bad request error' do
        get :validate

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Token not provided')
      end
    end
  end
end
