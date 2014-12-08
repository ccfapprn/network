class UserMail < ActionMailer::Base
  default from: Figaro.env.mailer_email

  def confirm_alt_email(user,link)
    @user = user
    @link = link
    mail(to: @user.alt_email, subject: 'confirm test message')
  end

end
