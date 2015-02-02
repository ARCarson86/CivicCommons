require "spec_helper"

describe RegionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { get: "/regions" }.should route_to(controller: "regions", action: "index")
    end

    it "recognizes and generates #show" do
      { get: "/regions/1" }.should route_to(controller: "regions", action: "show", id: "1")
    end

  end
end
