class User < ActiveRecord::Base

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
  
end
