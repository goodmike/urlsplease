class Request < ActiveRecord::Base
  
  include Taggable
  
  belongs_to :user
  has_many :resources
  
  validates :user, :presence => true
  validates :requirements, :presence => true
  
  # user is not accessible to mass assign: must be set explicitly
  attr_accessible :requirements
  
  scope :recent, order("requests.created_at DESC")
  
  def self.by_response_count
    Request.find_by_sql("SELECT requests.id, requests.requirements, 
      requests.user_id, requests.created_at, requests.updated_at, 
      users.nickname AS username,
      COALESCE(resources_external.count_id,0) AS response_count 
      FROM requests LEFT OUTER JOIN (SELECT resources.request_id,
      COUNT(resources.id) AS count_id FROM resources GROUP BY resources.request_id)
      resources_external ON requests.id = resources_external.request_id
      LEFT OUTER JOIN users ON requests.user_id = users.id
      ORDER BY response_count DESC
      LIMIT 100")
  end
  
  def excerpt(chars=100)
    return requirements unless requirements.length > chars
    pos = chars - 3
    while !(requirements[pos,1] =~ /\W+/) && pos > 0
      pos -= 1
    end
    requirements[0,pos] + "..."
  end

end
