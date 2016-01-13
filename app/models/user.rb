class User < ActiveRecord::Base
	has_secure_password

	  after_initialize :defaults
  validates_format_of :mobile, with: /\A(\d{10}|[+. ]\d{11})\z/

  def defaults
    self.role = 'employee' if self.role.nil?
    self.active = 'active' if self.active.nil?
  end

  def admin?
  	self.role == 'admin'
  end

  def active?
    self.active.downcase == 'active'
  end
  
  has_many :logs
end
