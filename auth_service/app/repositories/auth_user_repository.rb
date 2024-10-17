# frozen_string_literal: true

class AuthUserRepository

  def signup(user_params)
    user = User.new(user_params)
    if user.save
      { success: true, message: 'User created successfully', user_id: user.id }
    else
      { success: false, errors: user.errors.full_messages }
    end
  end
  
  def create(user_params)
    User.create(user_params)
  end

  def find_by_email(email)
    User.find_by(email: email)
  end

  def exists?(user_id)
    User.exists?(user_id)
  end
end
