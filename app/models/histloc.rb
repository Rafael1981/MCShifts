class Histloc < ActiveRecord::Base
  belongs_to :log
   geocoded_by :ip_address
   after_validation :geocode
end
