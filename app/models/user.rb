class User < ActiveRecord::Base
	has_secure_password

	  after_initialize :defaults

  def defaults
    self.role = 'employee' if self.role.nil?
  end

  def admin?
  	self.role == 'admin'
  end
end
