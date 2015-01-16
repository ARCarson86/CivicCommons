require File.dirname(__FILE__) + '/../spec_helper'

describe CuratedFeedItemController do

  describe "curated_feed" do
    it "retrieves information about a feed" do
      curated_feed = FactoryGirl.create(:curated_feed)
      get :curated_feed, :curated_feed_id => curated_feed.slug
      assigns(:curated_feed).should_not be_nil
    end
  end

end
