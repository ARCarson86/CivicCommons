require 'spec_helper'

module Admin

  describe UserRegistrationsController do

    it "recognizes and generates :new action" do
      { get: '/admin/user_registrations/new' }.should route_to(controller: 'admin/user_registrations', action: 'new')
    end

    it "recognizes and generates :create action" do
      { post: '/admin/user_registrations/' }.should route_to(controller: 'admin/user_registrations', action: 'create')
    end

  end

end
