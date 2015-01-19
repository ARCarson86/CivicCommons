require "spec_helper"

describe ProjectsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { get: "/projects" }.should route_to(controller: "projects", action: "index")
    end

  end
end
