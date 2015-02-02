require "spec_helper"

describe ManagedIssuePagesController do
  describe "routing" do

    it "recognizes and generates #show" do
      { :get => "/issues/20/pages/1" }.should route_to(controller: "managed_issue_pages", action: "show", issue_id: '20', id: '1')
    end

    it "does not recognize #index" do
      { :get => "/issues/20/pages" }.should_not be_routable
    end

    it "recognizes 'new' as #show with friendly-id" do
      { :get => "/issues/20/pages/new" }.should route_to(controller: "managed_issue_pages", action: "show", issue_id: '20', id: 'new')
    end

    it "does not recognize #edit" do
      { :get => "/issues/20/pages/1/edit" }.should_not be_routable
    end

    it "does not recognize #create" do
      { :post => "/issues/20/pages" }.should_not be_routable
    end

    it "does not recognize #update" do
      { :put => "/issues/20/pages/1" }.should_not be_routable
    end

    it "does not recognize #destroy" do
      { :delete => "/issues/20/pages/1" }.should_not be_routable
    end

  end
end
