class Tagging < ActiveRecord::Base
  
  belongs_to    :user
  belongs_to    :taggable, :polymorphic => true
  belongs_to    :tag
  
  attr_accessor :contents
  
  validates_uniqueness_of :tag_id, :scope => [:taggable_id, :taggable_type, :user_id]
  
  before_validation   :lookup_tag
  
  def ==(other)
    self.user == other.user                   && 
    self.taggable_type == other.taggable_type &&
    self.taggable_id   == other.taggable_id   &&
    self.tag_id        == other.tag_id
  end
  
  def lookup_tag()
    if contents.present? && self.tag.blank?
      self.tag = Tag.where(:contents => contents).first
      self.tag ||= Tag.new(:contents => contents)
    end
  end
end
