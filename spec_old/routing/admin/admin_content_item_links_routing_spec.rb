require 'spec_helper'

describe Admin::ContentItemLinksController do

  it 'recognizes and generates #index' do
    { get: 'admin/content_items/1/links' }.should route_to(controller: 'admin/content_item_links', action: 'index', content_item_id: '1')
  end

  it 'recognizes and generates #new' do
    { get: 'admin/content_items/1/links/new' }.should route_to(controller: 'admin/content_item_links', action: 'new', content_item_id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/content_items/1/links' }.should route_to(controller: 'admin/content_item_links', action: 'create', content_item_id: '1')
  end

  it 'recognizes and generates #edit' do
    { get: 'admin/content_items/1/links/2/edit' }.should route_to(controller: 'admin/content_item_links', action: 'edit', content_item_id: '1', id: '2')
  end
  
  it 'recognizes and generates #update' do
    { put: 'admin/content_items/1/links/2' }.should route_to(controller: 'admin/content_item_links', action: 'update', content_item_id: '1', id: '2')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/content_items/1/links/2' }.should route_to(controller: 'admin/content_item_links', action: 'destroy', content_item_id: '1', id: '2')
  end

end
