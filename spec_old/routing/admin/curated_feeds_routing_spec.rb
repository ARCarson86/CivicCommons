require "spec_helper"

describe Admin::CuratedFeedsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/curated_feeds" }.should route_to(:controller => "admin/curated_feeds", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/curated_feeds/new" }.should route_to(:controller => "admin/curated_feeds", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/curated_feeds/1" }.should route_to(:controller => "admin/curated_feeds", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/curated_feeds/1/edit" }.should route_to(:controller => "admin/curated_feeds", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/curated_feeds" }.should route_to(:controller => "admin/curated_feeds", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/curated_feeds/1" }.should route_to(:controller => "admin/curated_feeds", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/curated_feeds/1" }.should route_to(:controller => "admin/curated_feeds", :action => "destroy", :id => "1")
    end

  end
end
