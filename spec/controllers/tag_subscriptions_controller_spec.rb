require 'spec_helper'

describe TagSubscriptionsController do

  include Devise::TestHelpers
  include MockModels

  before(:each) do
    User.stub(:where) { [mock_user] }
    controller.stub(:current_user) { mock_user }
    request.env['warden'] = mock(Warden, :authenticate => mock_user, :authenticate! => mock_user)
  end
    
  describe "GET 'index'" do
    
    before(:each) do
      mock_user.stub(:tag_subscriptions) { [mock_tag] }
    end

    it "finds user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'index', :user_id => "foo"
    end
    
    it "returns an error if current user is not authorizing user" do
      controller.stub(:current_user) { mock_model(User) }
      get 'index', :user_id => "foo"
      response.code.should ==("404")
    end
    
    it "returns a routing error when no authorizing user is present" do
      lambda { get 'index' }.should raise_error(ActionController::RoutingError)
    end
    
    it "retrieves all tags to which user is subscribed" do
      mock_user.should_receive(:tag_subscriptions) { [mock_tag] }
      get 'index', :user_id => "foo"
    end
    
    it "assigns subscribed tags to view as 'tags'" do
      get 'index', :user_id => "foo"
      assigns[:tags].should ==( [mock_tag] )
    end
    
  end

  describe "GET 'show'" do
    
    
    it "finds user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'show', :user_id => "foo", :id => "bacon"
    end
    
    it "returns an error if current user is not authorizing user" do
      controller.stub(:current_user) { mock_model(User) }
      get 'show', :user_id => "foo", :id => "bacon"
      response.code.should ==("404")
    end
    
    it "returns a routing error when no authorizing user is present" do
      lambda { get 'show', :id => "bacon" }.should raise_error(ActionController::RoutingError)
    end
  end

  describe "GET 'new'" do
    
    it "finds user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      get 'new', :user_id => "foo"
    end
    
    it "returns an error if current user is not authorizing user" do
      controller.stub(:current_user) { mock_model(User) }
      get 'new', :user_id => "foo"
      response.code.should ==("404")
    end
    
    it "returns a routing error when no authorizing user is present" do
      lambda { get 'new' }.should raise_error(ActionController::RoutingError)
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      mock_user.stub(:subscribe)
    end
    
    it "finds user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      post 'create', :user_id => "foo", :new_tags => "one, two"
    end
    
    it "returns an error if current user is not authorizing user" do
      controller.stub(:current_user) { mock_model(User) }
      post 'create', :user_id => "foo", :new_tags => "one, two"
      response.code.should ==("404")
    end
    
    it "returns a routing error when no authorizing user is present" do
      lambda { post 'create', :new_tags => "one, two" }.should raise_error(ActionController::RoutingError)
    end
    
    it "updates sends new_tags param to user's subscribe method" do
      mock_user.should_receive(:subscribe).with("one, two")
      post 'create', :user_id => "foo", :new_tags => "one, two"
    end
    
    it "redirects to index view" do
      post 'create', :user_id => "foo", :new_tags => "one, two"
      response.should redirect_to(user_tag_subscriptions_url(mock_user))
    end
  end

  describe "DELETE 'destroy'" do
    
    before(:each) do
      Tag.stub(:where) { [mock_tag] }
      mock_tag.stub(:contents) { "bacon"}
      mock_user.stub(:unsubscribe_tag)
    end
    
    it "finds user by nickname" do
      User.should_receive(:where).with(:nickname => "foo") { [mock_user] }
      delete 'destroy', :user_id => "foo", :id => "bacon"
    end
    
    it "returns an error if current user is not authorizing user" do
      controller.stub(:current_user) { mock_model(User) }
      delete 'destroy', :user_id => "foo", :id => "bacon"
      response.code.should ==("404")
    end
    
    it "returns a routing error when no authorizing user is present" do
      lambda { delete 'destroy', :id => "bacon" }.should raise_error(ActionController::RoutingError)
    end
    
    it "finds tag for content" do
      Tag.should_receive(:where).with(:contents => "bacon") { [mock_tag] }
      delete 'destroy', :user_id => "foo", :id => "bacon"
    end
    
    it "should sends tag to user's unsubscribe_tag method" do
      mock_user.should_receive(:unsubscribe_tag).with(mock_tag)
      delete 'destroy', :user_id => "foo", :id => "bacon"
    end
    
    it "adds tags' contents to a notice message" do
      delete 'destroy', :user_id => "foo", :id => "bacon"
      flash[:notice].should contain("bacon")
    end
    
    it "redirects to index view" do
      delete 'destroy', :user_id => "foo", :id => "bacon"
      response.should redirect_to(user_tag_subscriptions_url(mock_user))
    end
  end
end