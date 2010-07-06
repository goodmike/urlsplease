class Tag < ActiveRecord::Base
  
  validates :contents, :presence => true
  
end
