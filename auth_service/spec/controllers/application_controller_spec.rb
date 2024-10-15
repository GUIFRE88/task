require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:user) { create(:user) }

  describe '#jwt_encode' do
    it 'encodes a payload into a JWT token' do
      payload = { user_id: user.id }
      token = subject.jwt_encode(payload)

      expect(token).to be_present
      decoded_payload = JWT.decode(token, ApplicationController::SECRET_KEY).first
      expect(decoded_payload['user_id']).to eq(user.id)
    end
  end

  describe '#jwt_decode' do
    it 'decodes a valid JWT token' do
      payload = { user_id: user.id }
      token = subject.jwt_encode(payload)
      decoded = subject.jwt_decode(token)

      expect(decoded[:user_id]).to eq(user.id)
    end

    it 'returns nil for an invalid token' do
      expect(subject.jwt_decode('invalid.token')).to be_nil
    end
  end

  describe '#authorize_request' do
    controller do
      before_action :authorize_request

      def index
        render json: { message: 'Success' }
      end
    end

    context 'when the user is not found' do
      let(:invalid_token) { subject.jwt_encode(user_id: 999) }

      before do
        request.headers['Authorization'] = "Bearer #{invalid_token}"
      end

      it 'returns an unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to eq('Invalid token')
      end
    end
  end
end
