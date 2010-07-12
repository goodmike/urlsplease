require 'spec_helper'

describe ResourcesController do

  include Devise::TestHelpers

  def mock_resource(stubs={})
    @mock_resource ||= mock_model(Resource, stubs).as_null_object
  end
  
  def mock_request(stubs={})
    @mock_request ||= mock_model(Request, stubs).as_null_object
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end
  
  before(:each) do
    @resources = []
    mock_user.stub(:resources) { @resources }
    controller.stub(:current_user) { mock_user }
    request.env['warden'] = mock_model(Warden, :authenticate => mock_user, :authenticate! => mock_user)
    mock_request.stub(:resources) { @resources }
    User.stub(:find).with("1") { mock_user }
    Request.stub(:find).with("2") { mock_request }
    @resources.stub(:find).with("3") { mock_resource }
  end

  describe "GET index" do
    
    describe "when no authorizing user is presented" do
      it "assigns all resources as @resources" do
        Resource.stub(:all) { [mock_resource] }
        get :index
        assigns(:resources).should eq([mock_resource])
      end
    end
    
    describe "when authorizing user is presented" do
      
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :index, :user_id => "1"
      end
      
      it "finds resources belonging to (i.e. posted by) user" do
        mock_user.should_receive(:resources).and_return([mock_resource])
        get :index, :user_id => "1"
      end
    end
  end

  describe "GET show" do
    
    describe "when authorizing user is present" do
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
        controller.stub(:current_user) { mock_user }
        @resources.stub(:find).with("2") { mock_resource }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :show, :user_id => "1", :id => "2"
      end
      
      it "looks up resource from user's resources" do
        @resources.should_receive(:find).with("2") { mock_resource }
        get :show, :user_id => "1", :id => "2"
      end
      
      it "allows a user to view another user's resource" do
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
    
    before(:each) do
      User.stub(:find).with("1") { mock_user }
      Request.stub(:find).with("2") { mock_request }
      controller.stub(:current_user) { mock_user }
      @resources.stub!(:build) { mock_resource }
    end

    describe "when authorizing user and request are present" do
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :new, :user_id => "1", :request_id => "2"
      end
      
      it "looks up request" do
        Request.should_receive(:find).with("2").and_return(mock_request)
        get :new, :user_id => "1", :request_id => "2"
      end
      
      it "builds a new resource from the request's resources collection" do
        mock_request.should_receive(:resources) { @resources }
        @resources.should_receive(:build) { mock_resource }
        get :new, :user_id => "1", :request_id => "2"
      end
      
      it "assigns user to the request" do
        mock_resource.should_receive(:user=).with(mock_user)
        get :new, :user_id => "1", :request_id => "2"
      end
      
      it "renders a 404 page if current user is not authorizing user" do
        controller.stub(:current_user) { mock_model(User) }
        controller.should_receive(:current_user) { mock_model(User) }
        get :new, :user_id => "1", :request_id => "2"
        response.code.should ==("404")
      end
      
      it "assigns new resource as @resource" do
        get :new, :user_id => "1", :request_id => "2"
        assigns(:resource).should be(mock_resource)
      end
    end
            
    it "returns a 404 error when no authorizing user is present" do
      get :new, :request_id => "2"
      response.code.should ==("404")
    end
    
    it "returns a 404 error when no authorizing request is present" do
      get :new, :user_id => "1"
      response.code.should ==("404")
    end
  end
  
  describe "GET edit" do
    
    describe "when authorizing user and request params are present" do
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :edit, :user_id => "1", :request_id => "2", :id => "3"
      end
            
      it "looks up request" do
        Request.should_receive(:find).with("2").and_return(mock_request)
        get :edit, :user_id => "1", :request_id => "2", :id => "3"
      end
      
      it "renders a 404 error if current user is not authorizing user" do
        controller.stub(:current_user) { mock_model(User) }
        get :edit, :user_id => "1", :request_id => "2", :id => "3"
        response.code.should ==("404")
      end
      
      it "finds response from request's responses" do
        mock_request.should_receive(:resources) { @resources }
        @resources.should_receive(:find).with("3") { mock_resource }
        get :edit, :user_id => "1", :request_id => "2", :id => "3"
      end
      
      it "assigns the resource as @resource" do
        get :edit, :user_id => "1", :request_id => "2", :id => "3"
        assigns(:resource).should be(mock_resource)
      end
    
    end
    
    it "returns a 404 error when no authorizing user is presented" do
      get :edit, :request_id => "2", :id => "3"
      response.code.should ==("404")
    end
    it "returns a 404 error when no authorizing request is presented" do
      get :edit, :user_id => "1", :id => "3"
      response.code.should ==("404")
    end
  end


  describe "POST create" do

    before(:each) do
      @resources.stub!(:build) { mock_resource(:save => true) }
      mock_resource.stub(:user=)
      @requesting_user = mock_model(User)
      mock_request.stub(:user) { @requesting_user }
    end
        
    describe "when authorizing user and request present" do
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
      end
      
      it "looks up request" do
        Request.should_receive(:find).with("2").and_return(mock_request)
        post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
      end
      
      it "returns a 404 error when current_user is not authenticated as user" do
        controller.stub(:current_user) { mock_model(User) }
        post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
        response.code.should ==("404")
      end
      
      
      describe "with valid params" do
        it "builds a new resource from the request's resources collection and assigns it as @resource" do
          mock_request.should_receive(:resources) { @resources }
          @resources.should_receive(:build).with({'these' => 'params'}) { mock_resource }
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
        end
        
        it "assigns the authorizing user as the resource's user" do
          mock_resource.should_receive(:user=).with(mock_user)
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
        end
        
        it "assigns the new resource as @resource" do
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
          assigns(:resource).should be(mock_resource)
        end
  
        it "redirects to the resource's request's page, using request's user id" do
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
          response.should redirect_to(user_request_url(@requesting_user, mock_request))
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved resource as @resource" do
          mock_resource.stub(:save) { false }
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
          assigns(:resource).should be(mock_resource)
        end
  
        it "re-renders the 'new' template" do
          mock_resource.stub(:save) { false }
          post :create, :user_id => "1", :request_id => "2", :resource => {'these' => 'params'}
          response.should render_template("new")
        end
      end
    end
    
    it "returns a 404 error when no authorizing user is present" do
      post :create, :request_id => "2", :resource => {'these' => 'params'}
      response.code.should ==("404")
    end
          
    it "returns a 404 error when no authorizing request is present" do
      post :create, :user_id => "1", :resource => {'these' => 'params'}
      response.code.should ==("404")
    end
  end
   
  describe "PUT update" do
    
    it "should render update template with 501 response code" do
      put :update, :user_id => "1", :request_id => "2", :id => "3"
      response.should render_template("update")
      response.code.should ==("501")
    end
  end
  
  describe "DELETE destroy" do
    
    it "should not be accessible by GET" do
      get :destroy, :user_id => "1", :request_id => "2", :id => "3"
      response.should_not be_success
    end
    
    describe "when authorizing user param is present" do
  
      before(:each) do
        @requests = []
        @requests.stub(:find).with("2") { mock_request }
        mock_user.stub(:requests) { @requests }
        mock_resource.stub(:destroy) 
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
      end
      
      it "returns a 404 error when current_user may not access user's resources" do
        controller.stub(:current_user) { mock_model(User) }
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
        response.code.should ==("404")
      end
      
      it "finds request from the user's requests collection" do
        mock_user.should_receive(:requests) { @requests }
        @requests.should_receive(:find).with("2") { mock_request }
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
      end
      
      it "finds resource from the authorizing request's resources collection" do
        @requests.should_receive(:find).with("2") { mock_request }
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
      end
    
      it "destroys the resource" do
        mock_resource.should_receive(:destroy)
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
      end
  
      it "should mark resources as removed instead of deleting record" do
        pending("to do")
      end
      
      it "redirects to the resource's request's page, using request's user id" do
        delete :destroy, :user_id => "1", :request_id => "2", :id => "3"
        response.should redirect_to(user_request_url(mock_user, mock_request))
      end
    end

    it "returns a 404 error when no authorizing user is present" do
      delete :destroy, :request_id => "2", :id => "3"
      response.code.should ==("404")
    end

    it "returns a 404 error when no authorizing request is present" do
      delete :destroy, :user_id => "1", :id => "3"
      response.code.should ==("404")
    end
  end

end
