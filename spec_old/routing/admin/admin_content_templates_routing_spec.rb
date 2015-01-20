require 'spec_helper'

describe Admin::ContentTemplatesController do

  it 'recognizes and generates #index' do
    { get: 'admin/content_templates' }.should route_to(controller: 'admin/content_templates', action: 'index')
  end

  it 'recognizes and generates #edit' do
    { get: 'admin/content_templates/1/edit' }.should route_to(controller: 'admin/content_templates', action: 'edit', id: '1')
  end

  it 'recognizes and generates #new' do
    { get: 'admin/content_templates/new' }.should route_to(controller: 'admin/content_templates', action: 'new')
  end

  it 'recognizes and generates #show' do
    { get: 'admin/content_templates/1' }.should route_to(controller: 'admin/content_templates', action: 'show', id: '1')
  end

  it 'recognizes and generates #update' do
    { put: 'admin/content_templates/1' }.should route_to(controller: 'admin/content_templates', action: 'update', id: '1')
  end

  it 'recognizes and generates #create' do
    { post: 'admin/content_templates' }.should route_to(controller: 'admin/content_templates', action: 'create')
  end

  it 'recognizes and generates #destroy' do
    { delete: 'admin/content_templates/1' }.should route_to(controller: 'admin/content_templates', action: 'destroy', id: '1')
  end

end
