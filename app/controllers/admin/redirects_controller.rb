class Admin::RedirectsController < Admin::DashboardController

  def index
    @redirect = Redirect.new
    @redirects = Redirect.all
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
    @redirect = Redirect.find params[:id]
  end
  
  def update
    @redirect = Redirect.find params[:id]
    @redirect.update_attributes params[:redirect]
    redirect_to admin_redirects_path
  end

  def destroy
    @redirect = Redirect.find params[:id]
    @redirect.destroy
    redirect_to admin_redirects_path
  end

end
