require 'spec_helper'

describe TagsController do

  include Devise::TestHelpers
  include MockModels

  before(:each) do
    request.env['warden'] = mock_model(Warden, :authenticate => mock_user, :authenticate! => mock_user)
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
      Tag.stub(:where) { [mock_tag] }
      @mock_request = mock_model(Request)
      @tagging_relation = []
      @tagging_relation.stub(:find_requests) { [@mock_request] }
      mock_tag.stub(:taggings) { @tagging_relation }
    end
    
    it "finds the requested tag by matching id param to record's contents" do
      Tag.should_receive(:where).with(:contents => "bunny") { [mock_tag] }
      get :show, :id => "bunny"
    end
    
    it "assigns the requested tag as @tag" do
      get :show, :id => "bunny"
      assigns(:tag).should be(mock_tag)
    end
    
    it "finds tag's recent requests and assigns them as @requests" do
      mock_tag.should_receive(:taggings) { @tagging_relation }
      @tagging_relation.should_receive(:find_requests) { [@mock_request] }
      get :show, :id => "bunny"
      assigns(:requests).should ==([@mock_request])
    end
  end



end
