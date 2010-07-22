module Taggable
  
  def Taggable.included(taggable)
    
    class_macros = <<-eos
      has_many :taggings, :as => :taggable
      attr_accessor   :new_tags
      attr_accessible :new_tags
      before_save :tag
    eos
    
    find_by_tags_method = <<-eos
      def self.find_by_tag(srch)
        if srch.is_a? Enumerable 
          contents = srch.collect { |item| Tag.taggify(item) }
        else
          contents = Tag.taggify(srch)
        end 
        self.joins(:taggings).where(
          :taggings => {:id => Tagging.joins(:tag).where(
            :tags => {:contents  => contents})})
      end
    eos
    
    taggable.class_eval class_macros
    taggable.class_eval find_by_tags_method
    
  end
  
  def tag(author = false, tag_string = false)
    author   ||= self.user
    new_tags = @new_tags || tag_string
    if new_tags
      Tag.split(new_tags).each do |contents|
        t = Tagging.new(:taggable => self, :user => author, :contents => contents)
        taggings.build(:user => author, :contents => contents) if t.valid?
      end
    end
  end
  
  def tags
    self.taggings.collect &:tag
  end

  

  
end