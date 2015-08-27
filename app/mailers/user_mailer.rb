class UserMailer < ActionMailer::Base
  default from: "from@example.com"

   def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def log_email(log, action, user)
    @log = log
    @user = user
    @action = action
    @url  = 'http://example.com/login'
    email_with_name = %("#{@user.firstname}" <#{@user.email}>)
    mail(to: @user.email, subject: 'Password Updated')
  end
end
