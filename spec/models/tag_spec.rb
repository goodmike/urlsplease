require 'spec_helper'

describe Tag do
  
  before(:each) do
    
  end
  
  it "does not allow records with duplicate contents string" do
    Tag.create(:contents => "bunnies")
    lambda { Tag.create!(:contents => "bunnies") }.should raise_error
  end
  
  it "does not singularize its contents string on initialization" do
    t = Tag.new(:contents => "bunnies")
    t.contents.should ==("bunnies")
  end
  
  it "downcases its content string" do
    t = Tag.new(:contents => "Bunny")
    t.contents.should ==("bunny")
  end
  
  it "converts camelcase contents into hyphen-separated string" do
    t = Tag.new(:contents => "purpleBunny")
    t.contents.should ==("purple-bunny")
  end
  
  it "strips away any punctuation" do
    t = Tag.new(:contents => "33!?@#\$%^}bunny!!!")
    t.contents.should ==("33bunny")
  end
  
  it "converts underscores, periods and semicolons into hypens" do
    t = Tag.new(:contents => "1.cool_blue;bunny")
    t.contents.should ==("1-cool-blue-bunny")
  end
  
  it "keeps ampersands in contents" do
    t = Tag.new(:contents => "bunnies&dragons")
    t.contents.should ==("bunnies&dragons")
  end
    
  it "removes preceding and trailing whitespace" do
    t = Tag.new(:contents => " bunny\t")
    t.contents.should ==("bunny")
  end
  
  it "return all tagged requests in reverse chronological order" do
    pending("This works, but is a pain in the ass to mock")
    tag.taggings.find_requests.should ==(expected_array)
  end
  
  it "uses contents as to-param value" do
    t = Tag.new(:contents => "bunny")
    t.to_param.should ==("bunny")
  end
  
  describe "providing a class method for breaking strings into tag-ready contents" do
    
    it "split on commas, whitepace, and plus signs" do
      Tag.split("one,two, three four+five+six").should ==(["one","two","three","four","five","six"])
    end
    
  end
end
