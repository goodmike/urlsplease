require 'spec_helper'

describe RequestsController do

  def mock_request(stubs={})
    @mock_request ||= mock_model(Request, stubs).as_null_object
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
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
        @requests = []
        @requests.stub(:find).with("2") { [mock_request] }
        mock_user.stub(:requests) { @requests }
      end
            
      it "looks up user" do
        User.should_receive(:find).with("1").and_return(mock_user)
        get :show, :user_id => "1", :id => "2"
      end
      
      it "determines whether current_user may access user's resources" do
        controller.should_receive(:current_user) { mock_user }
        get :show, :user_id => "1", :id => "2"
      end
      
      it "returns a 404 error when current_user may not access user's resources" do
        controller.stub(:current_user) { mock_model(User) }
        get :show, :user_id => "1", :id => "2"
        response.code.should ==("404")
      end
    end
    
    describe "when no authorizing user is present" do
      
      it "returns a 404 error" do
        get :show, :id => "2"
        response.code.should ==("404")
      end
    end
  end

#   describe "GET new" do
#     it "assigns a new tag as @tag" do
#       Tag.stub(:new) { mock_tag }
#       get :new
#       assigns(:tag).should be(mock_tag)
#     end
#   end
# 
#   describe "GET edit" do
#     it "assigns the requested tag as @tag" do
#       Tag.stub(:find).with("37") { mock_tag }
#       get :edit, :id => "37"
#       assigns(:tag).should be(mock_tag)
#     end
#   end
# 
#   describe "POST create" do
# 
#     describe "with valid params" do
#       it "assigns a newly created tag as @tag" do
#         Tag.stub(:new).with({'these' => 'params'}) { mock_tag(:save => true) }
#         post :create, :tag => {'these' => 'params'}
#         assigns(:tag).should be(mock_tag)
#       end
# 
#       it "redirects to the created tag" do
#         Tag.stub(:new) { mock_tag(:save => true) }
#         post :create, :tag => {}
#         response.should redirect_to(tag_url(mock_tag))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns a newly created but unsaved tag as @tag" do
#         Tag.stub(:new).with({'these' => 'params'}) { mock_tag(:save => false) }
#         post :create, :tag => {'these' => 'params'}
#         assigns(:tag).should be(mock_tag)
#       end
# 
#       it "re-renders the 'new' template" do
#         Tag.stub(:new) { mock_tag(:save => false) }
#         post :create, :tag => {}
#         response.should render_template("new")
#       end
#     end
# 
#   end
# 
#   describe "PUT update" do
# 
#     describe "with valid params" do
#       it "updates the requested tag" do
#         Tag.should_receive(:find).with("37") { mock_tag }
#         mock_tag.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => "37", :tag => {'these' => 'params'}
#       end
# 
#       it "assigns the requested tag as @tag" do
#         Tag.stub(:find) { mock_tag(:update_attributes => true) }
#         put :update, :id => "1"
#         assigns(:tag).should be(mock_tag)
#       end
# 
#       it "redirects to the tag" do
#         Tag.stub(:find) { mock_tag(:update_attributes => true) }
#         put :update, :id => "1"
#         response.should redirect_to(tag_url(mock_tag))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns the tag as @tag" do
#         Tag.stub(:find) { mock_tag(:update_attributes => false) }
#         put :update, :id => "1"
#         assigns(:tag).should be(mock_tag)
#       end
# 
#       it "re-renders the 'edit' template" do
#         Tag.stub(:find) { mock_tag(:update_attributes => false) }
#         put :update, :id => "1"
#         response.should render_template("edit")
#       end
#     end
# 
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested tag" do
#       Tag.should_receive(:find).with("37") { mock_tag }
#       mock_tag.should_receive(:destroy)
#       delete :destroy, :id => "37"
#     end
# 
#     it "redirects to the tags list" do
#       Tag.stub(:find) { mock_tag }
#       delete :destroy, :id => "1"
#       response.should redirect_to(tags_url)
#     end
#   end

end
