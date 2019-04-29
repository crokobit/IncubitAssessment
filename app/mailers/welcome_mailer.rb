class WelcomeMailer < ApplicationMailer
  default from: "inc@test.com"

  def welcome_mail(user)
    @user = user

    mail to: @user.email, subject: "Welcome #{@user.username}"
  end
end
