class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place

	delegate :client, :to => :place
 # validates_presence_of :Signin
 # validates_presence_of :Signout

	def defaults
		self.bonus = 0 if self.role.nil?
	end

end
