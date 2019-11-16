require 'bcrypt'
class UserEncryptionService
  include BCrypt
  attr_reader :user

  def initialize(user)
    @user = user
  end



  def compare_password(password_to_compare)
    bcrypt = ::BCrypt::Password.new(user.password)
    generated_password = ::BCrypt::Engine.hash_secret(password_to_compare, bcrypt.salt)
    user.password == generated_password
  end

  def encode_password
    Password.create(user.password)
  end

  def encode_refresh_token(token)
    Base64.encode64(token)
  end

  def decode_refresh_token
    Base64.decode64(user.refresh_token)
  end

end
