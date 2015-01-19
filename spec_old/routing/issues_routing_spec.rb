require "spec_helper"

describe IssuesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { get: "/issues" }.should route_to(controller: "issues", action: "index")
    end

    it "recognizes and generates #show" do
      { get: "/issues/1" }.should route_to(controller: "issues", action: "show", id: "1")
    end

    it "recognizes and generates #create_contribution" do
      { post: "/issues/1/create_contribution" }.should route_to(controller: "issues", action: "create_contribution", id: "1")
    end

  end
end
