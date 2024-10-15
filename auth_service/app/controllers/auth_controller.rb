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
    render json: { message: 'Token is valid' }, status: :ok
  end

  private

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