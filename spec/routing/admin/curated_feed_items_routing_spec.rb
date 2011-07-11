require 'spec_helper'

describe Admin::CuratedFeedItemsController do

  it "does not recognize #index" do
    { :get => 'admin/curated_feeds/20/items' }.should_not be_routable
  end

  it 'recognizes and generates #edit' do
    { get: 'admin/curated_feeds/20/items/1/edit' }.should route_to(controller: 'admin/curated_feed_items', action: 'edit', curated_feed_id: '20', id: '1')
  end

  # because of friendly_id this route appears to Rails to be a #show route
  #it "does not recognize #new" do
    #{ :get => 'admin/curated_feeds/20/items/new' }.should_not be_routable
  #end

  it 'recognizes and generates #show' do
    { get: 'admin/curated_feeds/20/items/1' }.should route_to(controller: 'admin/curated_feed_items', action: 'show', curated_feed_id: '20', id: '1')
  end

  it 'recognizes and generates #update' do
    { put: 'admin/curated_feeds/20/items/1' }.should route_to(controller: 'admin/curated_feed_items', action: 'update', curated_feed_id: '20', id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/curated_feeds/20/items' }.should route_to(controller: 'admin/curated_feed_items', action: 'create', curated_feed_id: '20')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/curated_feeds/20/items/1' }.should route_to(controller: 'admin/curated_feed_items', action: 'destroy', curated_feed_id: '20', id: '1')
  end

end
