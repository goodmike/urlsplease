require 'spec_helper'

describe Resource do
  
  def valid_attributes(uniq="")
    {
      :url => "http://someurl.tld"
    }
  end
  
  def mock_user(uniq="")
    mock_model(User, :nickname => "Nickname#{uniq}")
  end

  def mock_request(uniq="")
    mock_model(Request)
  end
  
  before(:each) do
    @resource         = Resource.new(valid_attributes)
    @resource.user    = mock_user
    @resource.request = mock_request
  end
    
  it "is valid with all required attributes" do
     @resource.should be_valid
  end

  it "is invalid without user" do
    @resource.user = nil
    @resource.should_not be_valid
  end

  it "is invalid without url" do
    @resource.url = nil
    @resource.should_not be_valid
  end

  it "is invalid without request" do
    @resource.request = nil
    @resource.should_not be_valid
  end

  it "is invalid with a URL that does not conform to the URI module" do
    @resource.url = "cookies and milk"
    @resource.should_not be_valid
  end
  
  it "is invalid with a URL that is over 255 characters long" do
    resource         = Resource.new(valid_attributes)
    resource.user    = mock_user("2")
    resource.request = mock_request("2)")
    resource.url = "http://contrived-url.com/overlong_query_thing_xxxxxx" +
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" +
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" + 
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" +
                    "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx257"
    resource.should_not be_valid
  end
  
  it "returns latest records first from `recent` scope" do
    r1 = Resource.new(valid_attributes); r1.request = mock_model(Request)
    r1.user = mock_model(User); r1.created_at = Time.now() - 2.minutes; r1.save
    r2 = Resource.new(valid_attributes); r2.request = mock_model(Request)
    r2.user = mock_model(User); r2.created_at = Time.now() - 3.minutes; r2.save
    r3 = Resource.new(valid_attributes); r3.request = mock_model(Request)
    r3.user = mock_model(User); r3.created_at = Time.now; r3.save
    r4 = Resource.new(valid_attributes); r4.request = mock_model(Request)
    r4.user = mock_model(User); r4.created_at = Time.now() - 1.minutes; r4.save
    
    Resource.recent.should ==([r3,r4,r1,r2])
  end
  
end