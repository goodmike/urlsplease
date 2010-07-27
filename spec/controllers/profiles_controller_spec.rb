require 'spec_helper'

describe ProfilesController do

  include Devise::TestHelpers
  include MockModels


  before(:each) do
    request.env['warden'] = mock_model(Warden, :authenticate => mock_user, :authenticate! => mock_user)
  end

  describe "GET 'show'" do
    
    before(:each) do
      User.stub(:where)           { [mock_user] }
      mock_user.stub(:tags)       { [mock_tag] }
      Request.stub(:find_by_tags) { [mock_request ] }
      mock_user.stub(:responses)  { [mock_resource] }
    end
    
    it "uses id to retrieve User by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'show', :id => "foo"
    end
    
    it "assigns user to view" do
      get 'show', :id => "foo"
      assigns[:user].should ==(mock_user)
    end
    
    it "retrieves user's subscribed tags" do
      mock_user.should_receive(:tags) { [mock_tag] }
      get 'show', :id => "foo"
    end
    
    it "retrieves requests for subscribed tags" do
      Request.should_receive(:find_by_tags).with([mock_tag]) { [mock_request] }
      get 'show', :id => "foo"
    end
    
    it "assigns the tags' requests as recommended requests" do
      get 'show', :id => "foo"
      assigns[:recommended_requests].should ==([mock_request])
    end
    
    it "retrieves the user's requests' recent responses" do
      mock_user.should_receive(:responses) { [mock_resource] }
      get 'show', :id => "foo"
    end
  end
  
  describe "GET 'edit'" do
    it "uses id to retrieve User by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'edit', :id => "foo"
      response.should be_success
    end
  end
  
  describe "GET 'update'" do
    it "uses id to retrieve User by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'update', :id => "foo"
      response.should be_success
    end
  end

end
