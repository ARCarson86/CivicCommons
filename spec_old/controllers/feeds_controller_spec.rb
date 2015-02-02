require 'spec_helper'

describe FeedsController do

  context "GET show" do

    it "assigns the requested CuratedFeed as @feed" do
      feed = FactoryGirl.create(:curated_feed)
      get :show, :id => feed.id, format: :xml
      assigns[:feed].should == feed
    end

    it "redirects to the feed index when the requested CuratedFeed is not found" do
      get :show, :id => 'does-not-exist'
      response.should redirect_to feeds_path
    end

  end

end
