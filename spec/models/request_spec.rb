require 'spec_helper'

describe Request do
  
  include MockModels
  
  def valid_attributes(uniq="")
    {
      :requirements => "Request requirements#{uniq}"
    }
  end
  
  def new_request(attrs={}, uniq="")
    r = Request.new(valid_attributes.with(attrs))
    r.user = mock_unique_user(uniq)
    r
  end
  
  def mock_unique_user(uniq="")
    mock_user(:nickname => "Nickname#{uniq}")
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
  

# Extractable to 'Taggable' behavior  
  
  describe "providing convenience method for tagging" do
    
    before(:each) do
      @req = new_request()
      @req.save
    end
    
    it "accepts a user for author and string for tag contents" do
      @req.tag(mock_user,"three, little pigs")
    end
    
    it "uses Tag's split method to split up tag string" do
      Tag.should_receive(:split).with("three, little pigs") {["three" "little" "pigs"]}
      @req.tag(mock_user,"three, little pigs")
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
  
  describe "finding by tags" do
    
    before(:each) do
      # Better than crazy mocking, but factory girl would likely be better still
      @requests = [new_request({:new_tags => "one"}, 1), new_request({:new_tags => "one two"}, 2)]
      @requests.each &:save
      @tag1 = Tag.find_by_contents("one")
      @tag2 = Tag.find_by_contents("two")
    end
    
    it "takes single tags or an array of tags as an argument" do
      Request.find_by_tags(@tag2).should ==(@requests[1..1])
      Request.find_by_tags([@tag2]).should ==(@requests[1..1])
    end
    
    it "does not return duplicate requests" do
      Request.find_by_tags([@tag1, @tag2]).should ==(@requests)
    end
    

  end
  
  describe "finding by tag contents search" do
    
    before(:each) do
      
      @taggings = []
      @requests = [mock_model(Request)]
      
      # Smelly mocking for arel associations
      Request.stub(:joins) { @requests }
      @requests.stub(:where) { @requests }
      Tagging.stub(:joins) { @taggings }
      @taggings.stub(:where) { @taggings }
      
      Tag.stub(:taggify) { "purple bunny" }
    end
    
    it "finds tag recrods for contents provided" do
      Request.should_receive(:joins).with(:taggings).and_return(@requests)
      Request.find_by_tag_contents("tagcontent")
    end
    
    it "converts search string into tag contents format" do
      Tag.should_receive(:taggify).and_return("purple bunny")
      Request.find_by_tag_contents("Purple Bunny")
    end
    
    describe "when multiple tag content strings are specified" do
      
      before(:each) do
        Tag.stub(:taggify).with("Purple").and_return("purple")
        Tag.stub(:taggify).with("bunnies").and_return("bunnies")
      end
    
      it "converts each string into tag contents format" do
        Tag.should_receive(:taggify).with("Purple").once().and_return("purple")
        Tag.should_receive(:taggify).with("bunnies").once().and_return("bunnies")
        Request.find_by_tag_contents(["Purple","bunnies"])
      end
      
      it "passes multiple contents to search" do
        @taggings.should_receive(:where).with(:tags => {:contents => ["purple","bunnies"]}) { @taggings }
        Request.find_by_tag_contents(["Purple","bunnies"])
      end
    end
  end
end