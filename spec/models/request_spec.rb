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
  
  describe "when saved with 'new_tags' attribute" do
    
    before(:each) do
      @req = new_request(:new_tags => "two, tags")
    end
    
    it "creates new records for taggings" do
      @req.save
      @req.taggings.size.should ==(2)
    end
    
    it "still saves request record when duplicate tagging is discovered" do
      @req = new_request()
      @req.new_tags = "two, tags"
      @req.save
      @req.new_tags = "two, more"
      assert @req.save
    end
  end
  
  it "returns tags from its taggings in response to :tags" do
    @req = new_request
    @req.tag(mock_user,"three, little, pigs")
    @req.tags.size.should ==(3)
  end
  
  it "can provide an excerpt string of a given number of characters from its requirements" do
    @req = new_request(:requirements => "This is a request of more than 80 characters. The excerpt should cut it off with ellipses before the 100 character mark.")
    @req.excerpt(80).should ==("This is a request of more than 80 characters. The excerpt should cut it off...")
  end
    
  it "defaults to an excerpt string 100 characters long" do
    @req = new_request(:requirements => "This is a request of more than 100 characters. The excerpt should cut it off with ellipses before the 80 character mark.")
    @req.excerpt.should ==("This is a request of more than 100 characters. The excerpt should cut it off with ellipses before...")
  end   
end