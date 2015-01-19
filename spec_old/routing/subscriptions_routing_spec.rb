require "spec_helper"

describe SubscriptionsController do

  describe "routing" do

    it "recognizes and generates #subscribe" do
      { post: "/subscriptions/subscribe" }.should route_to(controller: "subscriptions", action: "subscribe")
    end

    it "recognizes and generates #unsubscribe" do
      { post: "/subscriptions/unsubscribe" }.should route_to(controller: "subscriptions", action: "unsubscribe")
    end

  end

end
