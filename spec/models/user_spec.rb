require 'spec_helper'

describe User do
  
  def valid_attributes(uniq="")
    {
      :email    => "email#{uniq}@domain.tld",
      :nickname => "nickname#{uniq}",
      :password => "leet1337",
      :password_confirmation => "leet1337"
    }
  end
  
  it "is valid with all required attributes" do
     User.new(valid_attributes).should be_valid
  end

  it "is invalid without nickname" do
    User.new(valid_attributes.except(:nickname)).should_not be_valid
  end
  
  it "is invalid without email address" do
    User.new(valid_attributes.except(:email)).should_not be_valid
  end
  
  it "is invalid without password" do
    User.new(valid_attributes.except(:password)).should_not be_valid
  end
  
  it "is invalid without password_confirmation" do
    User.new(valid_attributes.except(:password_confirmation)).should_not be_valid
  end
  
  it "is invalid without a password of at least 8 characters" do
    # Set in config/initializers/devise.rb
    u = User.new(valid_attributes("2").with(:password => "too1337", :password_confirmation => "too1337"))
    u.should_not be_valid
    u.errors_on(:password).should be_present
    u.errors_on(:password)[0].should match(/too short/)
  end
  
  it "is invalid when nickname is already is use" do
    User.create!(valid_attributes)
    User.new(valid_attributes("2").with(:nickname => "nickname")).should_not be_valid
  end
  
  it "is invalid when email is already is use" do
    User.create!(valid_attributes)
    User.new(valid_attributes("2").with(:email => "email@domain.tld")).should_not be_valid
  end
  
  it "uses the user's nickname as to-param value" do
    u = User.new(valid_attributes.with(:nickname => "paramablenickname"))
    u.to_param.should ==("paramablenickname")
  end
  
# Extractable for taggable behavior 
  
  describe "providing convenience method for tagging" do
    
    before(:each) do
      @user = User.create(valid_attributes)
    end
    
    it "accepts a user for author and string for tag contents" do
      @user.tag(@user,"three, little pigs")
    end
    
    it "uses Tag's split method to split up tag string" do
      Tag.should_receive(:split).with("three, little pigs") {["three" "little" "pigs"]}
      @user.tag(@user,"three, little pigs")
    end
  end
  
  describe "when saved with 'new_tags' attribute" do
    
    before(:each) do
      @user = User.create(valid_attributes.with(:new_tags => "two, tags"))
    end
    
    it "creates new records for taggings" do
      @user.taggings.size.should ==(2)
    end
    
    it "still saves request record when duplicate tagging is discovered" do
      @user.new_tags = "two, more"
      assert @user.save
    end
    
  end
  
  describe "subscribe method" do
    
    before(:each) do
      @user = User.create(valid_attributes)
    end
    
    it "calls user.tag with user and subscribe's arguments" do
      @user = User.create(valid_attributes)
      @user.should_receive(:tag).with(@user, "one, two")
      @user.subscribe("one, two")
    end
    
    it "creates new records for taggings" do
      @user.subscribe("one, two")
      @user.taggings.size.should ==(2)
    end
    
    it "does not duplicate taggings" do
      user = User.create!(valid_attributes("foo").with(:new_tags => "two, tags"))
      user.subscribe("one, two")
      user.taggings.size.should ==(3)
    end
    
  end
  
  it "returns tags from its taggings in response to :tags" do
    @user = User.create(valid_attributes.with(:new_tags =>"three, little, pigs"))
    @user.tags.size.should ==(3)
  end
  
  describe "finding responses" do
    it "returns the resources posted to the user's requests" do
      # Replace this with factory methods
      @user = User.create!(valid_attributes)
      
      resource_1 = Resource.new(:url => "http://foo.bar")
      resource_1.user = @user
      resource_2 = Resource.new(:url => "http://foo.baz")
      resource_2.user = @user
      request_1 = @user.requests.create!(:requirements => "one")
      request_2 = @user.requests.create!(:requirements => "two")
      
      request_1.resources << resource_1
      request_2.resources << resource_2
      @user.responses.should include(resource_1,resource_2)
    end
  end
  
  describe "finding by tag search" do
    
    def mock_tag(stubs={})
      @mock_tag ||= mock_model(Tag, stubs)
    end
    
    before(:each) do
      
      @taggings = []
      @users = [mock_model(User)]
      
      # Smelly mocking for arel associations
      User.stub(:joins) { @users }
      @users.stub(:where) { @users }
      
      Tag.stub(:taggify) { "purple bunny" }
    end
  
    it "finds tag recrods for contents provided" do
      User.should_receive(:joins).with(:tags).and_return(@users)
      User.find_by_tag_contents("tagcontent")
    end
    
    it "converts search string into tag contents format" do
      Tag.should_receive(:taggify).and_return("purple bunny")
      User.find_by_tag_contents("Purple Bunny")
    end
    
    describe "when multiple tag content strings are specified" do
      
      before(:each) do
        Tag.stub(:taggify).with("Purple").and_return("purple")
        Tag.stub(:taggify).with("bunnies").and_return("bunnies")
      end
    
      it "converts each string into tag contents format" do
        Tag.should_receive(:taggify).with("Purple").once().and_return("purple")
        Tag.should_receive(:taggify).with("bunnies").once().and_return("bunnies")
        User.find_by_tag_contents(["Purple","bunnies"])
      end
      
      it "passes multiple contents to search" do
        @users.should_receive(:where).with(:tags => {:contents => ["purple","bunnies"]}) { @users }
        User.find_by_tag_contents(["Purple","bunnies"])
      end
    end
  end
  
  describe "handling tag subscriptions" do
    
    before(:each) do
      # Replace this with factory methods
      @user = User.create!(valid_attributes.with(:new_tags => "duck"))
      @duck = Tag.find_by_contents("duck")
      @newt = Tagging.create!(:contents=>"newt", :taggable => @user, :user => mock_model(User))
      @wood = Tagging.create!(:contents=>"wood", :taggable => mock_model(Request), :user => @user)
      @user.reload # So all these taggings are included
    end
  
    it "retrieves subscriptions as user-tagged tags which the user authored" do
      @user.tag_subscriptions.should ==([@duck])
    end

    it "removes a tagging for a tag subscription given a tag's contents" do
      @user.unsubscribe_tag(@duck)
      @user.tag_subscriptions.should ==([])
    end
    
    it "won't remove someone else's tagging of the user" do
      @user.unsubscribe_tag(Tag.find_by_contents("newt"))
      @user.tag_subscriptions.should ==([@duck])
      @user.taggings.should include(@newt)
    end
  end
end