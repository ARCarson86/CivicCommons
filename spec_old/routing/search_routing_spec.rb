require "spec_helper"

describe SearchController do
  describe "routing" do
    it "recognizes and generates #metro_region_city" do
      { get: '/search/metro_regions/city' }.should route_to(controller: "search", action: "metro_region_city")
    end    
  end
end
