require "spec_helper"

describe RequestsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/requests" }.should route_to(:controller => "requests", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/requests/new" }.should route_to(:controller => "requests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/requests/1" }.should route_to(:controller => "requests", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/requests/1/edit" }.should route_to(:controller => "requests", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/requests" }.should route_to(:controller => "requests", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/requests/1" }.should route_to(:controller => "requests", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/requests/1" }.should route_to(:controller => "requests", :action => "destroy", :id => "1") 
    end
    
    it "recognizes and generates #tag_search" do
      { :get => "requests/tagged/one+two" }.should route_to(
        :controller => "requests", :action => "tag_search", :search_string => "one+two")
    end

  end
  
  describe "nested routing within user scope" do
    
    it "recognizes #index" do
      assert_recognizes({:action=>"index", :controller=>"requests", :user_id=>"1"}, "/users/1/requests")
    end

    it "recognizes #new" do
      assert_recognizes({:action=>"new", :controller=>"requests", :user_id=>"1"}, "/users/1/requests/new")
    end
    
    it "recognizes #show" do
      assert_recognizes({:action=>"show", :controller=>"requests", :user_id=>"1", :id => "2"}, "/users/1/requests/2")
    end
    
    it "recognizes #edit" do
      assert_recognizes({:action=>"edit", :controller=>"requests", :user_id=>"1", :id => "2"}, "/users/1/requests/2/edit")
    end
    
    # it "recognizes #create" do
    #   assert_recognizes({:action=>"create", :controller=>"requests", :user_id=>"1"}, "/users/1/requests")
    # end
    # 
    # it "recognizes #update" do
    #   assert_recognizes({:action=>"update", :controller=>"requests", :user_id=>"1", :id => "2"}, "/users/1/requests/2")
    # end
    # 
    # it "recognizes #destroy" do
    #   assert_recognizes({:action=>"destroy", :controller=>"requests", :user_id=>"1", :id => "2"}, "/users/1/requests/2")
    # end

    
  end
end
