class Request < ActiveRecord::Base
  
  belongs_to :user
  has_many :resources
  has_many :taggings, :as => :taggable
  
  validates :user, :presence => true
  validates :requirements, :presence => true
  
  # user is not accessible to mass assign: must be set explicitly
  attr_accessor   :new_tags
  attr_accessible :requirements, :new_tags
  
  before_save :tag
  
  def tag(author = false, tag_string = false)
    author   ||= self.user
    new_tags = @new_tags || tag_string
    if new_tags
      new_tags.split(/,\w*/).each do |contents|
        t = Tagging.new(:taggable => self, :user => author, :contents => contents)
        taggings.build(:user => author, :contents => contents) if t.valid?
      end
    end
  end
  
  def tags
    self.taggings.collect &:tag
  end
  
  def excerpt(chars=100)
    return requirements unless requirements.length > chars
    pos = chars - 3
    while !(requirements[pos,1] =~ /\W+/) && pos > 0
      pos -= 1
    end
    requirements[0,pos] + "..."
  end
  
  def self.find_by_tag(srch)
    if srch.is_a? Enumerable 
      contents = srch.collect { |item| Tag.taggify(item) }
    else
      contents = Tag.taggify(srch)
    end 
    Request.joins(:taggings).where(
      :taggings => {:id => Tagging.joins(:tag).where(
        :tags => {:contents  => contents})})
  end
  
end
