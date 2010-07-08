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
    controller.stub(:current_user) { mock_user }
    request.env['warden'] = mock_model(Warden, :authenticate => mock_user, :authenticate! => mock_user)
    mock_user.stub(:resources) { @resources }
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
      
      before(:each) do
        User.stub(:find).with("1") { mock_user }
      end
      
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
        @resources.stub(:find).with("2") { [mock_resource] }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :show, :user_id => "1", :id => "2"
      end
      
      it "looks up resource from user's resources" do
        @resources.should_receive(:find).with("2") { [mock_resource] }
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
  
  # describe "GET new" do
  #   
  #   describe "when authorizing user is present" do
  #     
  #     before(:each) do
  #       User.stub(:find).with("1") { mock_user }
  #       controller.stub(:current_user) { mock_user }
  #       @resources.stub!(:build) { mock_resource }
  #     end
  #           
  #     it "looks up user" do
  #       User.should_receive(:find).with("1").and_return(mock_user)
  #       get :new, :user_id => "1"
  #     end
  #     
  #     it "determines whether current_user may access user's resources" do
  #       controller.should_receive(:current_user) { mock_user }
  #       get :new, :user_id => "1"
  #     end
  #     
  #     it "builds a new resource from the user's resources collection" do
  #       mock_user.should_receive(:resources) { @resources }
  #       @resources.should_receive(:build) { mock_resource }
  #       get :new, :user_id => "1"
  #     end
  #     
  #     it "assigns a new resource as @resource" do
  #       get :new, :user_id => "1"
  #       assigns(:resource).should be(mock_resource)
  #     end
  #     
  #     it "returns a 404 error when current_user may not access user's resources" do
  #       controller.stub(:current_user) { mock_model(User) }
  #       get :new, :user_id => "1"
  #       response.code.should ==("404")
  #     end
  #   end
  #   
  #   describe "when no authorizing user is present" do
  #     
  #     it "returns a 404 error" do
  #       get :new
  #       response.code.should ==("404")
  #     end
  #   end
  # end
  #  
  # describe "GET edit" do
  #   
  #   describe "when authorizing user is present" do
  #     
  #     before(:each) do
  #       User.stub(:find).with("1") { mock_user }
  #       controller.stub(:current_user) { mock_user }
  #       @resources.stub(:find).with("2") { mock_resource }
  #     end
  #           
  #     it "looks up user" do
  #       User.should_receive(:find).with("1").and_return(mock_user)
  #       get :edit, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "determines whether current_user may access user's resources" do
  #       controller.should_receive(:current_user) { mock_user }
  #       get :edit, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "finds a resource from the user's resources collection" do
  #       mock_user.should_receive(:resources) { @resources }
  #       @resources.should_receive(:find).with("2") { mock_resource }
  #       get :edit, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "assigns the resource as @resource" do
  #       get :edit, :user_id => "1", :id => "2"
  #       assigns(:resource).should be(mock_resource)
  #     end
  #     
  #     it "returns a 404 error when current_user may not access user's resources" do
  #       controller.stub(:current_user) { mock_model(User) }
  #       get :edit, :user_id => "1", :id => "2"
  #       response.code.should ==("404")
  #     end
  #   end
  # 
  #   describe "when no authorizing user is present" do
  #     
  #     it "returns a 404 error" do
  #       get :edit, :id => 2
  #       response.code.should ==("404")
  #     end
  #   end    
  # end
  # 
  # describe "POST create" do
  #   
  #   describe "when authorizing user is present" do
  #     
  #     before(:each) do
  #       User.stub(:find).with("1") { mock_user }
  #       controller.stub(:current_user) { mock_user }
  #       @resources.stub!(:build) { mock_resource(:save => true) }
  #     end
  #           
  #     it "looks up user" do
  #       User.should_receive(:find).with("1").and_return(mock_user)
  #       post :create, :user_id => "1", :resource => {'these' => 'params'}
  #     end
  #     
  #     it "determines whether current_user may access user's resources" do
  #       controller.should_receive(:current_user) { mock_user }
  #       post :create, :user_id => "1", :resource => {'these' => 'params'}
  #     end
  #     
  #     describe "with valid params" do
  #       it "builds a new resource from the user's resources collection and assigns it as @resource" do
  #         mock_user.should_receive(:resources) { @resources }
  #         @resources.should_receive(:build).with({'these' => 'params'}) { mock_resource }
  #         post :create, :user_id => "1", :resource => {'these' => 'params'}
  #       end
  #       
  #       it "assigns the new resource as @resource" do
  #         post :create, :user_id => "1", :resource => {'these' => 'params'}
  #         assigns(:resource).should be(mock_resource)
  #       end
  # 
  #       it "redirects to the created resource, using authorized user id" do
  #         post :create, :user_id => "1", :resource => {'these' => 'params'}
  #         response.should redirect_to(user_resource_url(mock_user, mock_resource))
  #       end
  #     end
  # 
  #     describe "with invalid params" do
  #       it "assigns a newly created but unsaved resource as @resource" do
  #         @resources.stub(:build) { mock_resource(:save => false) }
  #         post :create, :user_id => "1", :resource => {'these' => 'params'}
  #         assigns(:resource).should be(mock_resource)
  #       end
  # 
  #       it "re-renders the 'new' template" do
  #         @resources.stub(:build) { mock_resource(:save => false) }
  #         post :create, :user_id => "1", :resource => {'these' => 'params'}
  #         response.should render_template("new")
  #       end
  #     end
  #     
  #     it "returns a 404 error when current_user is not authenticated as user" do
  #       controller.stub(:current_user) { mock_model(User) }
  #       post :create, :user_id => "1", :resource => {'these' => 'params'}
  #       response.code.should ==("404")
  #     end
  #   end
  #   
  #   describe "when no authorizing user is present" do
  #     
  #     it "returns a 404 error" do
  #       post :create, :resource => {'these' => 'params'}
  #       response.code.should ==("404")
  #     end
  #   end
  # end
  #  
  # describe "PUT update" do
  #   
  #   describe "when authorizing user is present" do
  #     
  #     before(:each) do
  #       User.stub(:find).with("1") { mock_user }
  #       controller.stub(:current_user) { mock_user }
  #       @resources.stub!(:find) { mock_resource(:update_attributes => true) }
  #     end
  #           
  #     it "looks up user" do
  #       User.should_receive(:find).with("1").and_return(mock_user)
  #       put :update, :user_id => "1", :id => "2", :resource => {'these' => 'params'}
  #     end
  #     
  #     it "determines whether current_user is user" do
  #       controller.should_receive(:current_user) { mock_user }
  #       put :update, :user_id => "1", :id => "2", :resource => {'these' => 'params'}
  #     end
  #     
  #     describe "with valid params" do
  #       it "updates the resourceed resource" do
  #         @resources.should_receive(:find).with("2") { mock_resource }
  #         mock_resource.should_receive(:update_attributes).with({'these' => 'params'})
  #         put :update, :user_id => "1", :id => "2", :resource => {'these' => 'params'}
  #       end
  # 
  #       it "assigns the resourceed resource as @resource" do
  #         @resources.stub(:find) { mock_resource(:update_attributes => true) }
  #         put :update, :user_id => "1", :id => "2"
  #         assigns(:resource).should be(mock_resource)
  #       end
  # 
  #       it "redirects to the resource" do
  #         @resources.stub(:find) { mock_resource(:update_attributes => true) }
  #         put :update, :user_id => "1", :id => "2"
  #         response.should redirect_to(resource_url(mock_resource))
  #       end
  #     end
  # 
  #     describe "with invalid params" do
  #       it "assigns the resource as @resource" do
  #         @resources.stub(:find) { mock_resource(:update_attributes => false) }
  #         put :update, :user_id => "1", :id => "2"
  #         assigns(:resource).should be(mock_resource)
  #       end
  # 
  #       it "re-renders the 'edit' template" do
  #         @resources.stub(:find) { mock_resource(:update_attributes => false) }
  #         put :update, :user_id => "1", :id => "2"
  #         response.should render_template("edit")
  #       end
  #     end
  #   end
  #   
  #   describe "when no authorizing user is present" do
  #     
  #     it "returns a 404 error" do
  #       put :update, :id => "2", :resource => {'these' => 'params'}
  #       response.code.should ==("404")
  #     end
  #   end
  # end
  # 
  # describe "DELETE destroy" do
  #   
  #   it "should not be accessible by GET" do
  #     get :destroy, :user_id => "1", :id => "2"
  #     response.should_not be_success
  #   end
  #   
  #   describe "when authorizing user param is present" do
  # 
  #     before(:each) do
  #       User.stub(:find).with("1") { mock_user }
  #       controller.stub(:current_user) { mock_user }
  #       @resources.stub(:find).with("2") { mock_resource }
  #     end
  #           
  #     it "looks up user" do
  #       User.should_receive(:find).with("1").and_return(mock_user)
  #       delete :destroy, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "determines whether current_user may access user's resources" do
  #       controller.should_receive(:current_user) { mock_user }
  #       delete :destroy, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "finds a resource from the user's resources collection" do
  #       mock_user.should_receive(:resources) { @resources }
  #       @resources.should_receive(:find).with("2") { mock_resource }
  #       delete :destroy, :user_id => "1", :id => "2"
  #     end
  #     
  #     it "assigns the resource as @resource" do
  #       delete :destroy, :user_id => "1", :id => "2"
  #       assigns(:resource).should be(mock_resource)
  #     end
  #   
  #     it "does NOT destroy the resourceed resource" do
  #       mock_resource.should_not_receive(:destroy)
  #       delete :destroy, :user_id => "1", :id => "2"
  #     end
  # 
  #     it "displays the destroy view with code 501" do
  #       delete :destroy, :user_id => "1", :id => "2"
  #       response.should render_template("destroy")
  #       response.code.should ==("501")
  #     end
  #   
  #     it "returns a 404 error when current_user may not access user's resources" do
  #       controller.stub(:current_user) { mock_model(User) }
  #       get :edit, :user_id => "1", :id => "2"
  #       response.code.should ==("404")
  #     end
  #   end
  #   
  #   describe "when no authorizing user is present" do
  #     
  #     it "returns a 404 error" do
  #       delete :destroy, :id => "2"
  #       response.code.should ==("404")
  #     end
  #   end
  # end

end
