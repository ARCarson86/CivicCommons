require "spec_helper"

describe FeedsController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/feeds/1" }.should route_to(:controller => "feeds", :action => "show", :id => "1")
    end

    it "does not recognize #index" do
      { :get => "/feeds" }.should_not be_routable
    end

    it "recognizes 'new' as #show with friendly-id" do
      { :get => "/feeds/new" }.should route_to(:controller => "feeds", :action => "show", :id => "new")
    end

    it "does not recognize #edit" do
      { :get => "/feeds/1/edit" }.should_not be_routable
    end

    it "does not recognize #create" do
      { :post => "/feeds" }.should_not be_routable
    end

    it "does not recognize #update" do
      { :put => "/feeds/1" }.should_not be_routable
    end

    it "does not recognize #destroy" do
      { :delete => "/feeds/1" }.should_not be_routable
    end

  end
end
