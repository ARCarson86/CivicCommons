require 'spec_helper'

describe Admin::ContentItemsPeopleController do

  it 'recognizes and generates #index' do
    { get: 'admin/content_items/1/people' }.should route_to(controller: 'admin/content_items_people', action: 'index', content_item_id: '1')
  end

  it 'recognizes and generates #new' do
    { get: 'admin/content_items/1/people/new' }.should route_to(controller: 'admin/content_items_people', action: 'new', content_item_id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/content_items/1/people' }.should route_to(controller: 'admin/content_items_people', action: 'create', content_item_id: '1')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/content_items/1/people/2' }.should route_to(controller: 'admin/content_items_people', action: 'destroy', content_item_id: '1', id: '2')
  end

end
