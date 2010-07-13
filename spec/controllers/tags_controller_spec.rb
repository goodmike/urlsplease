require 'spec_helper'

describe TagsController do

  def mock_tag(stubs={})
    @mock_tag ||= mock_model(Tag, stubs).as_null_object
  end

  describe "GET index" do
    
    it "assigns all tags as @tags" do
      Tag.stub(:all) { [mock_tag] }
      get :index
      assigns(:tags).should eq([mock_tag])
    end
  end

  describe "GET show" do
    
    before(:each) do
      Tag.stub(:find) { mock_tag }
      @mock_request = mock_model(Request)
      @tagging_relation = []
      @tagging_relation.stub(:find_requests) { [@mock_request] }
      mock_tag.stub(:taggings) { @tagging_relation }
    end
    
    it "assigns the requested tag as @tag" do
      Tag.should_receive(:find).with("37") { mock_tag }
      get :show, :id => "37"
      assigns(:tag).should be(mock_tag)
    end
    
    it "finds tag's recent requests and assigns them as @requests" do
      mock_tag.should_receive(:taggings) { @tagging_relation }
      @tagging_relation.should_receive(:find_requests) { [@mock_request] }
      get :show, :id => "37"
      assigns(:requests).should ==([@mock_request])
    end
  end



end
