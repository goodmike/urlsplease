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
  
  it "returns tags from its taggings in response to :tags" do
    @user = User.create(valid_attributes)
    @user.tag(@user,"three, little, pigs")
    @user.tags.size.should ==(3)
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
      Tagging.stub(:joins) { @taggings }
      @taggings.stub(:where) { @taggings }
      
      Tag.stub(:taggify) { "purple bunny" }
    end
  
    it "finds tag recrods for contents provided" do
      User.should_receive(:joins).with(:taggings).and_return(@users)
      User.find_by_tag("tagcontent")
    end
    
    it "converts search string into tag contents format" do
      Tag.should_receive(:taggify).and_return("purple bunny")
      User.find_by_tag("Purple Bunny")
    end
    
    describe "when multiple tag content strings are specified" do
      
      before(:each) do
        Tag.stub(:taggify).with("Purple").and_return("purple")
        Tag.stub(:taggify).with("bunnies").and_return("bunnies")
      end
    
      it "converts each string into tag contents format" do
        Tag.should_receive(:taggify).with("Purple").once().and_return("purple")
        Tag.should_receive(:taggify).with("bunnies").once().and_return("bunnies")
        User.find_by_tag(["Purple","bunnies"])
      end
      
      it "passes multiple contents to search" do
        @taggings.should_receive(:where).with(:tags => {:contents => ["purple","bunnies"]}) { @taggings }
        User.find_by_tag(["Purple","bunnies"])
      end
    end
  end
  
end