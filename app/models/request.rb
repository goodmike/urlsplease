class Request < ActiveRecord::Base
  
  belongs_to :user
  has_many :resources
  
  attr_accessible :requirements
  
end
