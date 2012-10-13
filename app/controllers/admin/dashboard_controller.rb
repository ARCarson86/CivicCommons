require 'socket'
class Admin::DashboardController < ApplicationController

  before_filter :require_user
  authorize_resource :class => :admin_dashboard

  layout 'admin'

  def show
    @host = Socket.gethostname
  end

end
