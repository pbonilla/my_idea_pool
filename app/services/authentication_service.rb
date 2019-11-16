class AuthenticationService

  SESSION_TIMEOUT = 600

  attr_reader :user

  def initialize user
    @user = user
  end


  def create_session
    {
        jwt: jwt_session_creation,
        refresh_token: create_refresh_token
    }
  end

  def delete_session
    user.refresh_token = nil
    user.save
  end

  def self.is_session_active?(token)
    begin
      payload = JWT.decode token, Rails.application.secret_key_base, true, { algorithm: 'HS256' }
      { active: true, error: nil , current_user_id: payload.first['iss']}
    rescue JWT::ExpiredSignature
      { active: false, error: :expired }
    rescue JWT::DecodeError
      { active: false, error: :missing_valid_argument }
    end
  end

  def self.login?(params)
    user = User.where(email: params[:email]).first
    if user.present?
      encryption_service = UserEncryptionService.new(user)
      encryption_service.compare_password(params[:password]) ? AuthenticationService.new(user).create_session : nil
    else
      nil
    end
  end

  def self.refresh_session(refresh_token_provided)
    refresh_token_encoded = Base64.encode64(refresh_token_provided)
    user = User.where(refresh_token: refresh_token_encoded).first
    user.present? ? AuthenticationService.new(user).create_session : nil
  end

  private
  def jwt_session_creation
    payload = {
        iss: user.id,
        exp: (Time.now + SESSION_TIMEOUT.seconds).to_i
    }

    JWT.encode payload, Rails.application.secret_key_base, 'HS256'
  end

  def create_refresh_token
    random_string_generation = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
    refresh_token = Digest::SHA1.hexdigest( random_string_generation )
    update_user_refresh_token(refresh_token)
    refresh_token
  end

  def update_user_refresh_token(refresh_token)
    user.refresh_token = UserEncryptionService.new(user).encode_refresh_token(refresh_token)
    user.save
  end

end
