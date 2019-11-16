class UserForm
  include ActiveModel::Model

  attr_accessor :name, :email, :password

  validates :name, :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, format: { with: User::PASSWORD_REGEX_VALIDATION }

  def submit
    return false if invalid?
    true
  end
end
