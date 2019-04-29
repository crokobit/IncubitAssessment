class User < ApplicationRecord
  include BCrypt
  has_secure_password

  validate :check_username, on: :update
  validates :email, presence: true, uniqueness: true
  validate :password_length
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP

  before_create :set_user_name

  def check_username
    if changes[:username] && username.length < 5
      errors.add(:username, "username length must greater than five")
    end
  end

  def password_length
    errors.add(:password, "length must greater than 8") if password.present? && password.length < 8
  end

  def set_user_name
    prefix = email.split('@').first
    self.username = prefix
  end

  def set_reset_password_variables
    self.reset_digest = SecureRandom.urlsafe_base64
    self.reset_sent_at = DateTime.now
    save
  end

  def has_valid_reset_digest?
    DateTime.now.ago(6.hours) < reset_sent_at
  end

  def bcrypt_password
    @bcrypt_password ||= Password.new(password_digest)
  end
end
