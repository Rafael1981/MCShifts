class Place < ActiveRecord::Base
	has_many :logs
	belongs_to :client
end
