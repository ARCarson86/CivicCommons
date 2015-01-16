require "spec_helper"

describe CommunityController do

  describe "routing" do
    it "recognizes and generates #index" do
      { get: "/community" }.should route_to(controller: "community", action: "index")
    end
    it "recognizes and generates #index" do
      { get: "/issues/1/community" }.should route_to(controller: "community", action: "index", issue_id: '1')
    end
    
  end

end
