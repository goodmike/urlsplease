class UriValidator < ActiveModel::EachValidator
  
  require 'uri'
  
  def validate_each(record, attribute, value)
    begin
      uri = URI.parse(value)
    rescue URI::InvalidURIError
      record.errors[attribute] << 'does not appear to be a valid URI' 
    end
  end
  
end 
  

class Resource < ActiveRecord::Base
  
  include ActiveModel::Validations 
  
  belongs_to :user
  belongs_to :request
  
  # user and request are not accessible to mass assign: must be set explicitly
  attr_accessible :url
  
  validates :user, :presence => true
  validates :url,  :presence => true, :length => { :maximum => 256 }, :uri => true
  validates :request, :presence => true
  
  scope :recent, order("resources.created_at DESC")

end
