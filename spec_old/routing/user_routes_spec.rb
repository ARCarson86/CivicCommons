require "spec_helper"

describe UserController do

  describe "routing" do

    it "recognizes and generates #show" do
      { get: "/user/1" }.should route_to(controller: "user", action: "show", id: "1")
    end

    it "recognizes and generates #update" do
      { put: "/user/1" }.should route_to(controller: "user", action: "update", id: "1")
    end

    it "recognizes and generates #edit" do
      { get: "/user/1/edit" }.should route_to(controller: "user", action: "edit", id: "1")
    end

    it "recognizes and generates #edit" do
      { post: "/user/1/join_as_member" }.should route_to(controller: "user", action: "join_as_member", id: "1")
    end
    
    it "recognizes and generates #edit" do
      { delete: "/user/1/remove_membership" }.should route_to(controller: "user", action: "remove_membership", id: "1")
    end
    
    it "recognizes and generates #confirm_membership" do
      { get: "/user/confirm_membership" }.should route_to(controller: "user", action: "confirm_membership")
    end
    
  end

end
