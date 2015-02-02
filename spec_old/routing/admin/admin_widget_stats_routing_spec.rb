require "spec_helper"

describe Admin::WidgetStatsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/admin/widget_stats" }.should route_to(:controller => "admin/widget_stats", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/widget_stats/url/to/widget/here.embed" }.should route_to(:controller => "admin/widget_stats", :action => "show", :widget_url => "url/to/widget/here.embed")
    end
  end
end
