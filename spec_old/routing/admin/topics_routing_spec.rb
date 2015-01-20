require "spec_helper"

describe Admin::TopicsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/topics" }.should route_to(:controller => "admin/topics", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/topics/new" }.should route_to(:controller => "admin/topics", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/topics/1" }.should route_to(:controller => "admin/topics", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/topics/1/edit" }.should route_to(:controller => "admin/topics", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/topics" }.should route_to(:controller => "admin/topics", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/topics/1" }.should route_to(:controller => "admin/topics", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/topics/1" }.should route_to(:controller => "admin/topics", :action => "destroy", :id => "1")
    end

  end
end
