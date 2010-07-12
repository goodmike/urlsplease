class Tagging < ActiveRecord::Base
  
  belongs_to    :user
  belongs_to    :taggable, :polymorphic => true
  belongs_to    :tag
  
  attr_accessor :contents
  before_save   :lookup_tag
  
  def lookup_tag()
    if contents.present? && self.tag.blank?
      self.tag = Tag.where(:contents => contents).first
      self.tag ||= Tag.new(:contents => contents)
    end
  end
end
