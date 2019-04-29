class ResetPasswordMailer < ApplicationMailer
  default from: "inc@test.com"
  
  def reset_password_link(user, url)
    @user = user
    @url = url

    mail to: @user.email, subject: 'reset password mail'
  end
end
