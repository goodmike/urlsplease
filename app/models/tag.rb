class Tag < ActiveRecord::Base
  
  validates :contents, :presence => true, :uniqueness => true
  has_many :taggings
  
  def initialize(opts={})
    super
    self.contents = contents.gsub(/[^\w\d_\-\.; ]/,'').
                             gsub(/[\.;]/,' ').
                             strip.underscore.humanize.downcase.singularize if contents
  end
  
end
