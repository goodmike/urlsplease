require 'spec_helper'

describe Request do
  
  def valid_attributes(uniq="")
    {
      :requirements => "Request requirements#{uniq}"
    }
  end
  
  def new_request(attrs={})
    r = Request.new(valid_attributes.with(attrs))
    r.user = mock_user
    r
  end
  
  def mock_user(uniq="")
    mock_model(User, :nickname => "Nickname#{uniq}")
  end
  
  it "is valid with all required attributes" do
    r = Request.new(valid_attributes)
    r.user = mock_user
    r.should be_valid
  end

  it "is invalid without user" do
    Request.new(valid_attributes).should_not be_valid
  end
  
  it "is invalid without requirements" do
    r = Request.new(valid_attributes.except(:requirements))
    r.user = mock_user
    r.should_not be_valid
  end
  
  it "is invalid with blank requirements" do
    r = Request.new(valid_attributes.with(:requirements => ""))
    r.user = mock_user
    r.should_not be_valid
  end
  
  describe "providing convenience method for tagging" do
    
    before(:each) do
      @req = new_request()
      @req.save
    end
    
    it "accepts a user for author and string for tag contents" do
      @req.tag(mock_user,"three, little, pigs")
    end
    
    it "creates taggings for each comma-separated value in the contents string" do
      @req.tag(mock_user,"three, little, pigs")
      @req.taggings.size.should ==(3)
    end
  end
  
  it "returns tags from its taggings in response to :tags" do
    @req = new_request
    @req.tag(mock_user,"three, little, pigs")
    @req.tags.size.should ==(3)
  end
end