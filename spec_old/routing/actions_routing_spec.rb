require "spec_helper"

describe ActionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { get: "/conversations/123/actions" }.should route_to(controller: "actions", action: "index", :conversation_id => '123')
    end    
  end
end
