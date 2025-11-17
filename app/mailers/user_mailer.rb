class UserMailer < ApplicationMailer
  def confirmation(user, email_confirmation)
    @user = user
    @url = confirm_email_url(token: email_confirmation.token)
    mail to: user.email, subject: "Confirm your Email"
  end
end
