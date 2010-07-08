require "spec_helper"

describe ResourcesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/resources" }.should route_to(:controller => "resources", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/resources/new" }.should route_to(:controller => "resources", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/resources/1" }.should route_to(:controller => "resources", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/resources/1/edit" }.should route_to(:controller => "resources", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/resources" }.should route_to(:controller => "resources", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/resources/1" }.should route_to(:controller => "resources", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/resources/1" }.should route_to(:controller => "resources", :action => "destroy", :id => "1") 
    end
  end
  
  describe "nested routing within user scope" do
    
    it "recognizes #index" do
      assert_recognizes({:action=>"index", :controller=>"resources", :user_id=>"1"}, "/users/1/resources")
    end

    it "recognizes #show" do
      assert_recognizes({:action=>"show", :controller=>"resources", :user_id=>"1", :id => "2"}, "/users/1/resources/2")
    end
  end
  
  describe "nested routing within user and request scope" do
    
    it "recognizes #new" do
      assert_recognizes({:action=>"new", :controller=>"resources", :user_id=>"1", :request_id=>"2"}, 
                        "/users/1/requests/2/resources/new")
    end

    it "routes #create" do
      pending("crummy RSpec routing tools")
      assert_routing({ :method => 'post', :path => '/users/1/requests/2/resources' },
                     {:action=>"create", :controller=>"resources", :user_id=>"1", :request_id=>"2"})
    end
    it "recognizes #destroy" do
      pending("crummy RSpec routing tools")
      assert_recognizes({:action=>"destroy", :controller=>"resources", :user_id=>"1", :request_id=>"2", :id=>"3"}, 
                        "/users/1/requests/2/resources/3")
    end
    
  end
end
