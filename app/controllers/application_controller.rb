class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to '/login' unless current_user
  end

#to be used on admin user sessions controller
  def require_admin
    redirect_to '/' unless current_user && current_user.admin? 
  end

  def sms_signin(user,log)
    msg = user.firstname+' Signed in at ' + log.signin
    params = {'username' => ENV["SMS_USER"],
              'password'=> ENV["SMS_PASS"],
              'to'=> '0411654588',
              'from'=> 'MCShifts',
              'message'=> msg,
              'button1' => 'Submit'
    }
    # x = Net::HTTP.post_form(URI.parse('https://api.smsbroadcast.com.au/api-adv.php'), params)
    # puts x.body
  end

  def sms_signout(user,log)
    msg = user.firstname+' Signed out at ' + log.signout
    params = {'username' => ENV["SMS_USER"],
              'password'=> ENV["SMS_PASS"],
              'to'=> '0411654588',
              'from'=> 'MCShifts',
              'message'=> msg,
              'button1' => 'Submit'
    }
    # x = Net::HTTP.post_form(URI.parse('https://api.smsbroadcast.com.au/api-adv.php'), params)
    # puts x.body
  end

end
