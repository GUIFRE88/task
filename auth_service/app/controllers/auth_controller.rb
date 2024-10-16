# frozen_string_literal: true
class AuthController < ApplicationController
  before_action :authorize_request, except: [:login, :signup]

  # POST /signup
  def signup
    result = auth_user_service.signup(user_params)

    if result[:success]
      render json: { message: result[:message] }, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    result = auth_user_service.login(params[:email], params[:password])

    if result[:success]
      render json: { token: result[:token] }, status: :ok
    else
      render json: { error: result[:error] }, status: :unauthorized
    end
  end

  # GET /validate
  def validate
    token = request.headers['Authorization']&.split(' ')&.last

    if token
      result = auth_user_service.validate_token(token)

      if result[:valid]
        render json: { message: result[:message] }, status: :ok
      else
        render json: { error: result[:error] }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :bad_request
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def auth_user_service
    @auth_user_service ||= AuthUserService.new
  end
end
