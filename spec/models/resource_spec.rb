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
  # 
  # it "is invalid without email address" do
  #   User.new(valid_attributes.except(:email)).should_not be_valid
  # end
  # 
  # it "is invalid without password" do
  #   User.new(valid_attributes.except(:password)).should_not be_valid
  # end
  
end