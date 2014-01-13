class Admin::RedirectsController < Admin::DashboardController

  def index
    @redirect = Redirect.new
    @redirects = Redirect.all
  end

  def new
  end

  def create
    @redirect = Redirect.new params[:redirect]
    if @redirect.save
      redirect_to admin_redirects_path
    else
      Rails.logger.info @redirect.errors.full_messages
      @redirects = Redirect.all
      render :index
    end
  end

  def edit
  end
  
  def update
  end

  def destroy
  end

end
