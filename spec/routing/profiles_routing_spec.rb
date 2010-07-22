require "spec_helper"

describe ProfilesController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/profiles/1" }.should route_to(:controller => "profiles", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/profiles/1/edit" }.should route_to(:controller => "profiles", :action => "edit", :id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/profiles/1" }.should route_to(:controller => "profiles", :action => "update", :id => "1") 
    end
  end
end