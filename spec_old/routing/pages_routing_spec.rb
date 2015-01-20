require "spec_helper"

describe PagesController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/pages/1" }.should route_to(:controller => "pages", :action => "show", :id => "1")
    end

    it "does not recognize #index" do
      { :get => "/pages" }.should_not be_routable
    end

    it "recognizes 'new' as #show with friendly-id" do
      { :get => "/pages/new" }.should route_to(:controller => "pages", :action => "show", :id => "new")
    end

    it "does not recognize #edit" do
      { :get => "/pages/1/edit" }.should_not be_routable
    end

    it "does not recognize #create" do
      { :post => "/pages" }.should_not be_routable
    end

    it "does not recognize #update" do
      { :put => "/pages/1" }.should_not be_routable
    end

    it "does not recognize #destroy" do
      { :delete => "/pages/1" }.should_not be_routable
    end

  end
end
