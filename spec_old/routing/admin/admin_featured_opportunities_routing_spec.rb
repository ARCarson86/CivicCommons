require "spec_helper"

describe Admin::FeaturedOpportunitiesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/featured_opportunities" }.should route_to(:controller => "admin/featured_opportunities", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/featured_opportunities/new" }.should route_to(:controller => "admin/featured_opportunities", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/featured_opportunities/1" }.should route_to(:controller => "admin/featured_opportunities", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/featured_opportunities/1/edit" }.should route_to(:controller => "admin/featured_opportunities", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/featured_opportunities" }.should route_to(:controller => "admin/featured_opportunities", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/featured_opportunities/1" }.should route_to(:controller => "admin/featured_opportunities", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/featured_opportunities/1" }.should route_to(:controller => "admin/featured_opportunities", :action => "destroy", :id => "1")
    end

    it "recognizes and generates #change_conversation_selection" do
      { :get => "/admin/featured_opportunities/change_conversation_selection" }.should route_to(:controller => "admin/featured_opportunities", :action => "change_conversation_selection")
    end

  end
end
