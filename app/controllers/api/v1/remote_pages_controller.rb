class Api::V1::RemotePagesController < Api::V1::BaseController
  before_filter :get_remote_page_from_url, only: [:index]
  before_filter :get_remote_page, only: [:show, :edit, :delete]

  def index
  end

  def show
  end

  protected
  def get_remote_page_from_url
    return unless params[:remote_page_url]
    uri = URI.parse params[:remote_page_url]
    @remote_page = RemotePage.find_or_create_by_url uri.normalize.to_s
    redirect_to ['api', 'v1', @remote_page]
  end

  def get_remote_page
    @remote_page = RemotePage.find params[:id]
  end
end
