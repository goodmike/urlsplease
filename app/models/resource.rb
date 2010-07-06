class Resource < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :request
  
  # user and request are not accessible to mass assign: must be set explicitly
  attr_accessible :url
  
  validates :user, :presence => true
  validates :url, :presence => true
  validates :request, :presence => true
  
end
