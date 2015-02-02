require "spec_helper"

describe InvitesController do
  describe "routing" do

    it "recognizes and generates #new" do
      { :get => "/invites/new" }.should route_to(:controller => "invites", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/invites" }.should route_to(:controller => "invites", :action => "create")
    end

  end
end
