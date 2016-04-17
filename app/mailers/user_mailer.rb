class UserMailer < ActionMailer::Base
  default	from: "from@example.com"

   def welcome_email(user)
    @user = user
    mail(:to => ["mcshifts2016@gmail.com", @user.email], subject: 'Welcome to MCShifts')
  end

  def log_email(log, user)
    @log = log
    @user = user
    email_admins
    # mail(:to => ["mcshifts2016@gmail.com", @user.email], subject: 'New Sign In/Sign Out Information')
    mail(:to => @email_list, subject: 'New Sign In/Sign Out Information')
  end
end

#
private
  def email_admins
    @admin = User.all.where("role='admin'")
    @email_list = Array(@user.email)
    @admin.each do |admin|
      @email_list << admin.email
    end

  end