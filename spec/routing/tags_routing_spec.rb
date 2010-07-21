require "spec_helper"

describe TagsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/tags" }.should route_to(:controller => "tags", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/tags/new" }.should route_to(:controller => "tags", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tags/foo" }.should route_to(:controller => "tags", :action => "show", :id => "foo")
    end

    it "recognizes and generates #edit" do
      { :get => "/tags/foo/edit" }.should route_to(:controller => "tags", :action => "edit", :id => "foo")
    end

    it "recognizes and generates #create" do
      { :post => "/tags" }.should route_to(:controller => "tags", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/tags/foo" }.should route_to(:controller => "tags", :action => "update", :id => "foo") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tags/foo" }.should route_to(:controller => "tags", :action => "destroy", :id => "foo") 
    end

  end
end
