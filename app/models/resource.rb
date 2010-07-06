class Resource < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :request
  
  attr_accessible :url
  
end
