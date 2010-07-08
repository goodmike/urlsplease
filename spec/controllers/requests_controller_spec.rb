require 'spec_helper'

describe RequestsController do

  include Devise::TestHelpers

  def mock_request(stubs={})
    @mock_request ||= mock_model(Request, stubs).as_null_object
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end
  
  before(:each) do
    @requests = []
    controller.stub(:current_user) { mock_user }
    request.env['warden'] = mock_model(Warden, :authenticate => mock_user, :authenticate! => mock_user)
    mock_user.stub(:requests) { @requests }
  end

  describe "GET index" do
    
    describe "when no authorizing user is presented" do
      it "assigns all requests as @requests" do
        Request.stub(:all) { [mock_request] }
        get :index
        assigns(:requests).should eq([mock_request])
      end
    end
    
    describe "when authorizing user is presented" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
      end
      
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :index, :user_id => "1"
      end
      
      it "finds requests belonging to user" do
        mock_user.should_receive(:requests).and_return([mock_request])
        get :index, :user_id => "1"
      end
    end
  end

  describe "GET show" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub(:find).with("2") { [mock_request] }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :show, :user_id => "1", :id => "2"
      end
      
      it "looks up request from user's requests" do
        @requests.should_receive(:find).with("2") { [mock_request] }
        get :show, :user_id => "1", :id => "2"
      end
      
      it "allows a user to view another user's request" do
        controller.stub(:current_user) { mock_model(User) }
        get :show, :user_id => "1", :id => "2"
        response.should be_success
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        get :show, :id => "2"
        response.code.should ==("404")
      end
    end
  end

  describe "GET new" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub!(:build) { mock_request }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :new, :user_id => "1"
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        get :new, :user_id => "1"
      end
      
      it "builds a new request from the user's requests collection" do
        mock_user.should_receive(:requests) { @requests }
        @requests.should_receive(:build) { mock_request }
        get :new, :user_id => "1"
      end
      
      it "assigns a new request as @request" do
        get :new, :user_id => "1"
        assigns(:request).should be(mock_request)
      end
      
      it "returns a 404 error when current_user may not access user's resources" do
        controller.stub(:current_user) { mock_model(User) }
        get :new, :user_id => "1"
        response.code.should ==("404")
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        get :new
        response.code.should ==("404")
      end
    end
  end
 
  describe "GET edit" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub(:find).with("2") { mock_request }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :edit, :user_id => "1", :id => "2"
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        get :edit, :user_id => "1", :id => "2"
      end
      
      it "finds a request from the user's requests collection" do
        mock_user.should_receive(:requests) { @requests }
        @requests.should_receive(:find).with("2") { mock_request }
        get :edit, :user_id => "1", :id => "2"
      end
      
      it "assigns the request as @request" do
        get :edit, :user_id => "1", :id => "2"
        assigns(:request).should be(mock_request)
      end
      
      it "returns a 404 error when current_user may not access user's resources" do
        controller.stub(:current_user) { mock_model(User) }
        get :edit, :user_id => "1", :id => "2"
        response.code.should ==("404")
      end
    end
  
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        get :edit, :id => 2
        response.code.should ==("404")
      end
    end    
  end

  describe "POST create" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub!(:build) { mock_request(:save => true) }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        post :create, :user_id => "1", :request => {'these' => 'params'}
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        post :create, :user_id => "1", :request => {'these' => 'params'}
      end
      
      describe "with valid params" do
        it "builds a new request from the user's requests collection and assigns it as @request" do
          mock_user.should_receive(:requests) { @requests }
          @requests.should_receive(:build).with({'these' => 'params'}) { mock_request }
          post :create, :user_id => "1", :request => {'these' => 'params'}
        end
        
        it "assigns the new request as @request" do
          post :create, :user_id => "1", :request => {'these' => 'params'}
          assigns(:request).should be(mock_request)
        end

        it "redirects to the created request, using authorized user id" do
          post :create, :user_id => "1", :request => {'these' => 'params'}
          response.should redirect_to(user_request_url(mock_user, mock_request))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved request as @request" do
          @requests.stub(:build) { mock_request(:save => false) }
          post :create, :user_id => "1", :request => {'these' => 'params'}
          assigns(:request).should be(mock_request)
        end

        it "re-renders the 'new' template" do
          @requests.stub(:build) { mock_request(:save => false) }
          post :create, :user_id => "1", :request => {'these' => 'params'}
          response.should render_template("new")
        end
      end
      
      it "returns a 404 error when current_user is not authenticated as user" do
        controller.stub(:current_user) { mock_model(User) }
        post :create, :user_id => "1", :request => {'these' => 'params'}
        response.code.should ==("404")
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        post :create, :request => {'these' => 'params'}
        response.code.should ==("404")
      end
    end
  end
 
  describe "PUT update" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub!(:find) { mock_request(:update_attributes => true) }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        put :update, :user_id => "1", :id => "2", :request => {'these' => 'params'}
      end
      
      it "determines whether current_user is user" do
        controller.should_receive(:current_user) { mock_user }
        put :update, :user_id => "1", :id => "2", :request => {'these' => 'params'}
      end
      
      describe "with valid params" do
        it "updates the requested request" do
          @requests.should_receive(:find).with("2") { mock_request }
          mock_request.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :user_id => "1", :id => "2", :request => {'these' => 'params'}
        end

        it "assigns the requested request as @request" do
          @requests.stub(:find) { mock_request(:update_attributes => true) }
          put :update, :user_id => "1", :id => "2"
          assigns(:request).should be(mock_request)
        end

        it "redirects to the request" do
          @requests.stub(:find) { mock_request(:update_attributes => true) }
          put :update, :user_id => "1", :id => "2"
          response.should redirect_to(request_url(mock_request))
        end
      end

      describe "with invalid params" do
        it "assigns the request as @request" do
          @requests.stub(:find) { mock_request(:update_attributes => false) }
          put :update, :user_id => "1", :id => "2"
          assigns(:request).should be(mock_request)
        end

        it "re-renders the 'edit' template" do
          @requests.stub(:find) { mock_request(:update_attributes => false) }
          put :update, :user_id => "1", :id => "2"
          response.should render_template("edit")
        end
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        put :update, :id => "2", :request => {'these' => 'params'}
        response.code.should ==("404")
      end
    end
  end

  describe "DELETE destroy" do
    
    it "should not be accessible by GET" do
      get :destroy, :user_id => "1", :id => "2"
      response.should_not be_success
    end
    
    describe "when authorizing user param is present" do

      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @requests.stub(:find).with("2") { mock_request }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        delete :destroy, :user_id => "1", :id => "2"
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        delete :destroy, :user_id => "1", :id => "2"
      end
      
      it "finds a request from the user's requests collection" do
        mock_user.should_receive(:requests) { @requests }
        @requests.should_receive(:find).with("2") { mock_request }
        delete :destroy, :user_id => "1", :id => "2"
      end
      
      it "assigns the request as @request" do
        delete :destroy, :user_id => "1", :id => "2"
        assigns(:request).should be(mock_request)
      end
    
      it "does NOT destroy the requested request" do
        mock_request.should_not_receive(:destroy)
        delete :destroy, :user_id => "1", :id => "2"
      end

      it "displays the destroy view with code 501" do
        delete :destroy, :user_id => "1", :id => "2"
        response.should render_template("destroy")
        response.code.should ==("501")
      end
    
      it "returns a 404 error when current_user may not access user's resources" do
        controller.stub(:current_user) { mock_model(User) }
        get :edit, :user_id => "1", :id => "2"
        response.code.should ==("404")
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        delete :destroy, :id => "2"
        response.code.should ==("404")
      end
    end

  end

end
