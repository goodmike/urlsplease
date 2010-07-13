require 'spec_helper'

describe Tagging do
  
  def mock_tag(stubs={})
    @mock_tag ||= mock_model(Tag, stubs)
  end
  
  def mock_user(uniq="")
    @mock_user ||= mock_model(User, :nickname => "Nickname#{uniq}")
  end

  def mock_request(uniq="")
    @mock_request ||= mock_model(Request)
  end
  
  def valid_attributes(attrs={})
    {
      :user     => mock_user,
      :taggable => mock_request,
      :tag      => mock_tag
    }
  end
  
  it "enforces uniqueness of tag, user author, and taggable" do
    mock_request = mock_model(Request)
    mock_user    = mock_model(User)
    Tagging.create(:tag => mock_tag, :user => mock_user, :taggable => mock_request)
    Tagging.create(:tag => mock_tag, :user => mock_user, :taggable => mock_request)
    Tagging.all.size.should ==(1)
  end
  
  it "detects equality (==) based on equality of user, tag, and taggable" do
    tag   = Tagging.new(valid_attributes)
    tcopy = Tagging.new(valid_attributes)
    tag.should ==(tcopy)
  end
  
  describe "on initialization" do
    
    before(:each) do
      Tag.stub(:where) { [mock_tag] }
      Tag.stub(:create) { mock_tag }
    end
    
    describe "when contents string is provided instead of Tag object" do
      it "checks for tag with contents" do
        Tag.should_receive(:where).with(:contents => "tazer")
        Tagging.create(:contents=>"tazer")
      end
      
      it "assigns its tag to existing tag with contents" do
        t = Tagging.create(:contents=>"tazer")
        t.tag.should ==(mock_tag)
      end
      
      it "builds a new tag with contents if no existing tag is found" do
        Tag.stub(:where) { [] }
        Tag.should_receive(:new) { mock_tag }
        t = Tagging.new(valid_attributes().with(:tag => nil, :contents=>"tazer"))
        t.save
      end
      
      it "should check for Tag uniqueness violation consrtaint on Tag creation" do
        pending("Just in case race conditions become possible")
      end
    end
  end
end
