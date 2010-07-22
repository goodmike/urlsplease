class Request < ActiveRecord::Base
  
  include Taggable
  
  belongs_to :user
  has_many :resources
  
  validates :user, :presence => true
  validates :requirements, :presence => true
  
  # user is not accessible to mass assign: must be set explicitly
  attr_accessible :requirements
  
  def excerpt(chars=100)
    return requirements unless requirements.length > chars
    pos = chars - 3
    while !(requirements[pos,1] =~ /\W+/) && pos > 0
      pos -= 1
    end
    requirements[0,pos] + "..."
  end

end
