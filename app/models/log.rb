class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
	# has_many :histloc
 # validates_presence_of :Signin
 # validates_presence_of :Signout


end
