class Request < ActiveRecord::Base
  
  belongs_to :user
  has_many :resources
  
  validates :user, :presence => true
  validates :requirements, :presence => true
  
  # user is not accessible to mass assign: must be set explicitly
  attr_accessible :requirements
  
end
