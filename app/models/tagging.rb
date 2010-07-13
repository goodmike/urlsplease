class Tagging < ActiveRecord::Base
  
  belongs_to    :user
  belongs_to    :taggable, :polymorphic => true
  belongs_to    :tag
  
  attr_accessor :contents
  
  validates_uniqueness_of :tag_id, :scope => [:taggable_id, :taggable_type, :user_id]
  
  before_validation   :lookup_tag
  
  def lookup_tag()
    if contents.present? && self.tag.blank?
      new_tag = Tag.new(:contents => contents)
      self.tag = Tag.where(:contents => new_tag.contents).first || new_tag
    end
  end
end
