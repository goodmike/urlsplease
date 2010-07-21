class Tag < ActiveRecord::Base
  
  validates :contents, :presence => true, :uniqueness => true
  has_many :taggings do
    def find_requests(limit=10)
      reqs = where(:taggable_type => "Request").limit(limit).collect &:taggable
      reqs.sort {|a,b| b.created_at <=> a.created_at }
    end
  end
  
  def initialize(opts={})
    super
    self.contents = Tag.taggify(contents) if contents
  end
  
  def self.taggify(str)
    str.gsub(/[^\w\d_\-\.; ]/,'').
        gsub(/[\.;]/,' ').
        strip.underscore.humanize.downcase.singularize
  end
  
  def to_param
    contents
  end
  
end
