require "spec_helper"

describe MetroRegionsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { post: "/metro_regions/filter/1234" }.should route_to(controller: "metro_regions", action: "filter", :metrocode => '1234')
    end
  end
end