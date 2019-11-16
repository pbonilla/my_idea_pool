class User < ApplicationRecord

  PASSWORD_REGEX_VALIDATION = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}/

  validates :email, uniqueness: true

  around_create :encrypt_password

  private

  def encrypt_password
    password_service = UserEncryptionService.new(self)
    self.password = password_service.encode_password
    yield
  end
end

