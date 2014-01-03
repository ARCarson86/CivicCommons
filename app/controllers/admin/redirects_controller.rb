class Admin::RedirectsController < Admin::DashboardController

  def index
    @new_redirect = Redirect.new
    @redirects = Redirect.all
  end

  def new
  end

  def create
  end

  def edit
  end
  
  def update
  end

  def destroy
  end

end
