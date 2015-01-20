require 'spec_helper'

describe Admin::RegionsController do

  it "generates and recognizes #index" do
    { get: 'admin/regions/' }.should route_to(controller: 'admin/regions', action: 'index')
  end

  it "generates and recognizes #edit" do
    { get: 'admin/regions/1/edit' }.should route_to(controller: 'admin/regions', action: 'edit', id: '1')
  end

  it "generates and recognizes #new" do
    { get: 'admin/regions/new' }.should route_to(controller: 'admin/regions', action: 'new')
  end

  it "generates and recognizes #show" do
    { get: 'admin/regions/1' }.should route_to(controller: 'admin/regions', action: 'show', id: '1')
  end

  it "generates and recognizes #update" do
    { put: 'admin/regions/1' }.should route_to(controller: 'admin/regions', action: 'update', id: '1')
  end

  it "generates and recognizes #create" do
    { post: 'admin/regions/' }.should route_to(controller: 'admin/regions', action: 'create')
  end

  it "generates and recognizes #destroy" do
    { delete: 'admin/regions/1' }.should route_to(controller: 'admin/regions', action: 'destroy', id: '1')
  end

end
