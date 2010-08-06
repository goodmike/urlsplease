class User < ActiveRecord::Base

  include Taggable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates :nickname, :presence => true,
                       :uniqueness => true
  
  has_many :resources
  has_many :requests

  # Setup accessible (or protected) attributes for your model
  attr_accessible :nickname, :email, :password, :password_confirmation
  
  validates :password_confirmation, :presence => true
  
  def to_param
    nickname
  end
  
  def responses
    Resource.joins(:request).where(
      :requests => {:id => Request.joins(:user).where(:users => {:id => self})})
  end
  
# User-specific customizations to Taggable

  def user
    self
  end
  
  def subscribe(tag_string)
    self.tag(self, tag_string)
    self.taggings.each &:save
  end
  
  def tag_subscriptions
    Tag.joins(:taggings).
        where(:taggings => {:user_id => self, :taggable_id => self, 
                                              :taggable_type => self.class.name})
  end
  
  def unsubscribe_tag(tag)
    tagging = self.taggings.where(:tag_id => tag).first
    tagging.destroy if tagging && tagging.user == self
  end
  
end
