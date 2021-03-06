class Admin::RemotePagesController < Admin::DashboardController
  before_filter :get_remote_page, only: [:destroy]

  def index
    @q = RemotePage.ransack(params[:q])
    @remote_pages = @q.result.order("ISNULL(title), title asc").paginate(page: params[:page])
  end

  def destroy
    @remote_page.destroy
    redirect_to admin_remote_pages_path, notice: 'Your page has been deleted'
  end

  protected

  def get_remote_page
    @remote_page = RemotePage.find params[:id]
  end
end
