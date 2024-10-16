class ApplicationController < ActionController::API
  require 'httparty'

  before_action :authenticate_user

  private
  def authenticate_user
    puts 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
    token = request.headers['Authorization']&.split(' ')&.last
    response = HTTParty.get("#{ENV['AUTH_SERVICE_URL']}/validate", headers: { 'Authorization' => "Bearer #{token}" })

    render json: { errors: 'Unauthorized' }, status: :unauthorized unless response.success?
  end
end
