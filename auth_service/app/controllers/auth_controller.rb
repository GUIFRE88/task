class AuthController < ApplicationController
  before_action :authorize_request, except: [:login, :signup]

  # POST /signup
  def signup
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # GET /validate
  def validate
    token = request.headers['Authorization']&.split(' ')&.last
  
    if token
      begin
        decoded_token = decode_token(token)
        user_id = decoded_token[0]['user_id']
        if User.exists?(user_id)
          render json: { message: 'Token is valid' }, status: :ok
        else
          render json: { error: 'Invalid token' }, status: :unauthorized
        end
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :bad_request
    end
  end

  private

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
  end

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end

# Como autenticar rotas no sistema principal. 
#class ApplicationController < ActionController::API
#  before_action :authenticate_user
#
#  private

#  def authenticate_user
#    token = request.headers['Authorization']&.split(' ')&.last
#    response = HTTParty.get("#{AUTH_SERVICE_URL}/validate", headers: { 'Authorization' => "Bearer #{token}" })
#    render json: { errors: 'Unauthorized' }, status: :unauthorized unless response.success?
#  end
#end