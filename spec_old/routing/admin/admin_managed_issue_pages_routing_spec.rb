require 'spec_helper'

describe Admin::ManagedIssuePagesController do

  it 'recognizes and generates #all' do
    { get: 'admin/issues/pages/all' }.should route_to(controller: 'admin/managed_issue_pages', action: 'all')
  end

  it 'recognizes and generates #index' do
    { get: 'admin/issues/20/pages' }.should route_to(controller: 'admin/managed_issue_pages', action: 'index', issue_id: '20')
  end

  it 'recognizes and generates #edit' do
    { get: 'admin/issues/20/pages/1/edit' }.should route_to(controller: 'admin/managed_issue_pages', action: 'edit', issue_id: '20', id: '1')
  end

  it 'recognizes and generates #new' do
    { get: 'admin/issues/20/pages/new' }.should route_to(controller: 'admin/managed_issue_pages', action: 'new', issue_id: '20')
  end

  it 'recognizes and generates #show' do
    { get: 'admin/issues/20/pages/1' }.should route_to(controller: 'admin/managed_issue_pages', action: 'show', issue_id: '20', id: '1')
  end

  it 'recognizes and generates #update' do
    { put: 'admin/issues/20/pages/1' }.should route_to(controller: 'admin/managed_issue_pages', action: 'update', issue_id: '20', id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/issues/20/pages' }.should route_to(controller: 'admin/managed_issue_pages', action: 'create', issue_id: '20')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/issues/20/pages/1' }.should route_to(controller: 'admin/managed_issue_pages', action: 'destroy', issue_id: '20', id: '1')
  end

end
