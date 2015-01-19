require 'spec_helper'

describe Admin::DashboardController do

  it 'recognizes and generates #show' do
    { get: 'admin/' }.should route_to(controller: 'admin/dashboard', action: 'show')
  end

  it 'recognizes the root path' do
    { get: admin_root_path }.should route_to(controller: 'admin/dashboard', action: 'show')
  end

end
