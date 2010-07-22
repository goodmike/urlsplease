require 'spec_helper'

describe UsersController do

  include Devise::TestHelpers
  include MockModels
   
  describe "GET show" do
    
    before(:each) do
      mock_user.stub(:tags)         { [mock_tag] }
      mock_user.stub(:requests)     { [mock_request] }
      mock_user.stub(:resources)    { [mock_resource] }
      
      User.stub(:where)             { [mock_user] }
    end
    
    it "retrieves user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get :show, :id => "foo"
    end
    
    it "retrieves tags from user" do
      mock_user.should_receive(:tags) { [mock_tag] }
      get :show, :id => "foo"
    end
    
    it "assigns tags to view" do
      get :show, :id => "foo"
      assigns[:tags].should ==([mock_tag])
    end
    
    it "retrieves user's requests " do
      mock_user.should_receive(:requests) { [mock_request] }
      get :show, :id => "foo"
    end
    
    it "assigns requests to view" do
      get :show, :id => "foo"
      assigns[:requests].should ==([mock_request])
    end
    
    it "retrieves user's resources " do
      mock_user.should_receive(:resources) { [mock_resource] }
      get :show, :id => "foo"
    end
    
    it "assigns resources to view" do
      get :show, :id => "foo"
      assigns[:resources].should ==([mock_resource])
    end
    
  end
  
  
  
end