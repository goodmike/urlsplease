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
  
  describe "finding by tag search" do
    
    def mock_tag(stubs={})
      @mock_tag ||= mock_model(Tag, stubs)
    end
    
    before(:each) do
      
      @taggings = []
      @requests = [mock_model(Request)]
      
      Request.stub(:joins) { @requests }
      @requests.stub(:where) { @requests }
      Tagging.stub(:joins) { @taggings }
      @taggings.stub(:where) { @taggings }
      
      Tag.stub(:taggify) { "purple bunny" }
    end
    
    it "finds tag recrods for contents provided" do
      Request.should_receive(:joins).with(:taggings).and_return(@requests)
      Request.find_by_tag("tagcontent")
    end
    
    it "converts search string into tag contents format" do
      Tag.should_receive(:taggify).exactly(7).times.and_return("purple bunny")
      Request.find_by_tag("purple bunnies")
      Request.find_by_tag("Purple Bunny")
      Request.find_by_tag("purple_bunny")
      Request.find_by_tag("purpleBunny")
      Request.find_by_tag("purple&@#\$%^} bunny!!!")
      Request.find_by_tag("purple;bunny")
      Request.find_by_tag(" purple bunny\t")
    end
    
    describe "when multiple tag content strings are specified" do
      
      before(:each) do
        Tag.stub(:taggify).with("Purple").and_return("purple")
        Tag.stub(:taggify).with("bunnies").and_return("bunny")
      end
    
      it "converts each string into tag contents format" do
        Tag.should_receive(:taggify).with("Purple").once().and_return("purple")
        Tag.should_receive(:taggify).with("bunnies").once().and_return("bunny")
        Request.find_by_tag(["Purple","bunnies"])
      end
      
      it "passes multiple contents to search" do
        @taggings.should_receive(:where).with(:tags => {:contents => ["purple","bunny"]}) { @taggings }
        Request.find_by_tag(["Purple","bunnies"])
      end
    end
  end
end