class User < ApplicationRecord
  has_secure_password
  include BCrypt
  validate :check_username, on: :update
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  before_create :set_user_name

  def set_user_name
    prefix = email.split('@').first
    self.username = prefix
  end

  def check_username
    if changes[:username] && username.length < 5
      errors.add(:username, "username length must greater than five")
    end
  end

  def password
    @password ||= Password.new(password_digest)
  end
end
