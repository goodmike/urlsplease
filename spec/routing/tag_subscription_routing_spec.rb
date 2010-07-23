require "spec_helper"

describe TagSubscriptionsController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/users/foo/tag_subscriptions/bacon" }.should route_to(
        :controller => "tag_subscriptions", :user_id => "foo", :action => "show", :id => "bacon")
    end

    it "recognizes and generates #index" do
      { :get => "/users/foo/tag_subscriptions" }.should route_to(
        :controller => "tag_subscriptions", :user_id => "foo", :action => "index")
    end
    
    it "recognizes and generates #new" do
      { :get => "/users/foo/tag_subscriptions/new" }.should route_to(
        :controller => "tag_subscriptions", :user_id => "foo", :action => "new")
    end
    
    it "recognizes and generates #create" do
      { :post => "/users/foo/tag_subscriptions" }.should route_to(
        :controller => "tag_subscriptions", :user_id => "foo", :action => "create") 
    end
    
    it "recognizes and generates #destroy" do
      { :delete => "/users/foo/tag_subscriptions/bacon" }.should route_to(
        :controller => "tag_subscriptions", :user_id => "foo", :action => "destroy", :id => "bacon") 
    end
  end
end
