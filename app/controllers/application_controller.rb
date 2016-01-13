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

  def sms(user,log,action)
    if (action == 0)
      msg = user.firstname+' Signed in at ' + Time.parse(log.signin.to_s).strftime('%d/%m/%Y %H:%M')#log.signin
    else
      msg = user.firstname+' Signed out at ' + Time.parse(log.signout.to_s).strftime('%d/%m/%Y %H:%M')#log.signout
    end
    mobile_admins
    @mobile_list.each do |m|
      params = {'username' => ENV["SMS_USER"],
                'password'=> ENV["SMS_PASS"],
                'to'=> m,
                'from'=> 'MCShifts',
                'message'=> msg,
                'button1' => 'Submit'
      }
      x = Net::HTTP.post_form(URI.parse('https://api.smsbroadcast.com.au/api-adv.php'), params)
      puts x.body
    end
  end


  def mobile_admins
    admin = User.all.where('role="admin"')
    if admin.count == 1
      @mobile_list = Array(admin.first.mobile)
    else
      cnt = 0
      admin.each do |a|
        if cnt > 0
          @mobile_list << a.mobile
        end
        cnt = cnt + 1
      end
    end

  end

end
