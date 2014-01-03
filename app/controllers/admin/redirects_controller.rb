class Admin::RedirectsController < Admin::DashboardController

  def index
    @redirects = Redirect.all
  end

end
