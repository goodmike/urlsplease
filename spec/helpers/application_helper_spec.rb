require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TagsHelper. For example:
# 
# describe TagsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ApplicationHelper do
  
  include MockModels
  
  before(:each) do
    @time = Time.utc(2000,"jan",15,20,15,1)
    @created_object = mock(:created_at => @time)
  end
  
  describe "date and time formatting method" do
    
    it "applies a date-time format to a Time object" do
      dateandtime(@time, "%m/%d/%Y %I:%M%p").should ==("01/15/2000 08:15PM")
    end
    
    it "applies the format '%b %d %Y, %I:%M %p' by default" do
      dateandtime(@time).should ==("Jan 15 2000, 08:15 PM")
    end
    
    it "can be passed an object with a created_at method and will format the created_at value" do
      dateandtime(@created_object).should ==("Jan 15 2000, 08:15 PM")
    end
    
    it "returns an error string for display when method can't find a date or time" do
      dateandtime(Object.new).should =~(/cannot be parsed/)
    end
    
  end
  
  describe "date-only version of formatting method" do
     
     it "returns the format '%b %d %Y'" do
       dateonly(@time).should ==("Jan 15 2000")
     end
     
    it "can be passed an object with a created_at method and will format the created_at value" do
      dateonly(@created_object).should ==("Jan 15 2000")
    end
    
    it "returns an error string for display when method can't find a date or time" do
      dateonly(Object.new).should =~(/cannot be parsed/)
    end
  end
  
  describe "tag listing method" do
    
    it "lists comma-separated tag contents, each linked to tag show path" do
      tags = [mock_model(Tag, :contents => "bunnies", :to_param => "bunnies"),
               mock_model(Tag, :contents => "bacon", :to_param => "bacon")]
      linked_tags(tags).should ==('<a href="/tags/bunnies">bunnies</a>, <a href="/tags/bacon">bacon</a>')
    end
  end
  
  
  describe "user listing method" do
    
    before(:each) do
      mock_user.stub!(:nickname => "user's nickname")
    end
    
    it "returns nickname of a user" do
      user(mock_user).should ==("user's nickname")
    end
    
    it "can take any object that has a user attribute" do
      obj = mock(:user => mock_user)
      user(obj).should ==("user's nickname")
    end
    
    it "returns an error string for display when method can't find a user" do
      user(Object.new).should =~(/cannot find/i)
    end
  end
  
end