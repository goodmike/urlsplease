require 'spec_helper'

describe Tag do
  
  before(:each) do
    
  end
  
  it "does not allow records with duplicate contents string" do
    Tag.create(:contents => "bunnies")
    lambda { Tag.create!(:contents => "bunnies") }.should raise_error
  end
  
  it "singularizes its contents string on initialization" do
    t = Tag.new(:contents => "bunnies")
    t.contents.should ==("bunny")
  end
  
  it "downcases its content string" do
    t = Tag.new(:contents => "Bunny")
    t.contents.should ==("bunny")
  end
  
  it "converts underscores in contents into spaces" do
    t = Tag.new(:contents => "purple_bunny")
    t.contents.should ==("purple bunny")
  end
  
  it "converts camelcase contents into space-separated string" do
    t = Tag.new(:contents => "purpleBunny")
    t.contents.should ==("purple bunny")
  end
  
  it "strips away any punctuation" do
    t = Tag.new(:contents => "33&@#\$%^}bunny!!!")
    t.contents.should ==("33bunny")
  end
  
  it "converts periods and semicolons into spaces" do
    t = Tag.new(:contents => "1.blue;bunny")
    t.contents.should ==("1 blue bunny")
  end
    
  it "removes preceding and trailing whitespace" do
    t = Tag.new(:contents => " 1 bunny\t")
    t.contents.should ==("1 bunny")
  end
  
  
end
