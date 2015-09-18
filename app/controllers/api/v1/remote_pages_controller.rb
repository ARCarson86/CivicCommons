class Api::V1::RemotePagesController < Api::V1::BaseController
  # before_filter :get_remote_page_from_url, only: [:index]
  before_filter :get_remote_page, only: [:show, :edit, :delete]

  def index
    if params[:source_key].present?
      get_remote_page_from_source_key
    else
      get_remote_page_from_url
    end
  end

  def show
  end

  protected
  def get_remote_page_from_url
    return unless params[:remote_page_url]
    uri = URI.parse params[:remote_page_url]
    @remote_page = RemotePage.find_or_create_by_url uri.normalize.to_s do |r|
      r.source_key = params[:source_key] || ""
      r.root_domain = params[:root_domain] || ""
    end

    redirect_to ['api', 'v1', @remote_page]
  end

  def get_remote_page_from_source_key
    return unless params[:source_key]
    uri = URI.parse params[:remote_page_url]
    root_domain = params[:root_domain] || uri.host
    @remote_page = RemotePage.find_or_create_by_source_key_and_root_domain(params[:source_key], root_domain) do |r|
      r.url = params[:remote_page_url] || ""
    end

    redirect_to ['api', 'v1', @remote_page]
  end

  def get_remote_page
    @remote_page = RemotePage.find params[:id]
  end
end
