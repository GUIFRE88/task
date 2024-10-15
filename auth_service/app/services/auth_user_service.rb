# frozen_string_literal: true

class AuthUserService
  def signup(user_params)
    auth_user_repository.signup(user_params)
  end

  def login(email, password)
    user = auth_user_repository.find_by_email(email)
    if user&.authenticate(password)
      token = jwt_encode(user_id: user.id)
      { success: true, token: token }
    else
      { success: false, error: 'Invalid email or password' }
    end
  end

  def validate_token(token)
    begin
      decoded_token = decode_token(token)
      user_id = decoded_token[0]['user_id']
      if User.exists?(user_id)
        { valid: true, message: 'Token is valid' }
      else
        { valid: false, error: 'Invalid token' }
      end
    rescue JWT::DecodeError
      { valid: false, error: 'Invalid token' }
    end
  end

  private

  def jwt_encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def decode_token(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
  end

  def auth_user_repository
    @auth_user_repository ||= AuthUserRepository.new
  end
end
