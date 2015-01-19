require 'spec_helper'

describe Admin::ContentItemsController do

  it 'recognizes and generates #index' do
    { get: 'admin/content_items' }.should route_to(controller: 'admin/content_items', action: 'index')
  end

  it 'recognizes and generates #index with "type" filter' do
    { get: 'admin/content_items/type/blog_post' }.should route_to(controller: 'admin/content_items', action: 'index', type: 'blog_post')
  end

  it 'recognizes and generates #edit' do
    { get: 'admin/content_items/1/edit' }.should route_to(controller: 'admin/content_items', action: 'edit', id: '1')
  end

  it 'recognizes and generates #new' do
    { get: 'admin/content_items/new' }.should route_to(controller: 'admin/content_items', action: 'new')
  end

  it 'recognizes and generates #show' do
    { get: 'admin/content_items/1' }.should route_to(controller: 'admin/content_items', action: 'show', id: '1')
  end

  it 'recognizes and generates #update' do
    { put: 'admin/content_items/1' }.should route_to(controller: 'admin/content_items', action: 'update', id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/content_items' }.should route_to(controller: 'admin/content_items', action: 'create')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/content_items/1' }.should route_to(controller: 'admin/content_items', action: 'destroy', id: '1')
  end

end
