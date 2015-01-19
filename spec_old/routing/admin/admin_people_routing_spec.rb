require 'spec_helper'

describe Admin::PeopleController do

  it "generates and recognizes #index" do
    { get: 'admin/people/' }.should route_to(controller: 'admin/people', action: 'index')
  end

  it "generates and recognizes #new" do
    { get: 'admin/people/new' }.should route_to(controller: 'admin/people', action: 'new')
  end

  it "generates and recognizes #edit" do
    { get: 'admin/people/1/edit' }.should route_to(controller: 'admin/people', action: 'edit', id: '1')
  end
  
  it "generates and recognizes #export_members" do
    { get: 'admin/people/export_members' }.should route_to(controller: 'admin/people', action: 'export_members')
  end

  it "genereates and recognizes #show" do
    { get: 'admin/people/1' }.should route_to(controller: 'admin/people', action: 'show', id: '1')
  end

  it "generates and recognizes #update" do
    { put: 'admin/people/1' }.should route_to(controller: 'admin/people', action: 'update', id: '1')
  end

  it "generates and recognizes #create" do
    { post: 'admin/people/' }.should route_to(controller: 'admin/people', action: 'create')
  end

  it "genereates and recognizes #destroy" do
    { delete: 'admin/people/1' }.should route_to(controller: 'admin/people', action: 'destroy', id: '1')
  end

  it "generates and recognizes #proxies" do
    { get: 'admin/people/proxies' }.should route_to(controller: 'admin/people', action: 'proxies')
  end

  it "generates and recognizes #lock_access" do
    { put: 'admin/people/1/lock_access' }.should route_to(controller: 'admin/people', action: 'lock_access', id: '1')
  end

  it "generates and recognizes #unlock_access" do
    { put: 'admin/people/1/unlock_access' }.should route_to(controller: 'admin/people', action: 'unlock_access', id: '1')
  end

  it "generates and recognizes #confirm" do
    { put: 'admin/people/1/confirm' }.should route_to(controller: 'admin/people', action: 'confirm', id: '1')
  end

end
