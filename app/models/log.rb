class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :place
  validates_presence_of :Signin
  validates_presence_of :Signout


end
