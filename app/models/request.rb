class Request < ActiveRecord::Base
  
  belongs_to :user
  has_many :resources
  has_many :taggings, :as => :taggable
  
  validates :user, :presence => true
  validates :requirements, :presence => true
  
  # user is not accessible to mass assign: must be set explicitly
  attr_accessible :requirements
  
  def tag(author, tag_string)
    tags = tag_string.split(/,\w*/)
    tags.each do |contents|
      taggings.build(:user => author, :contents => contents)
    end
  end
  
  def tags
    self.taggings.collect &:tag
  end
  
end
