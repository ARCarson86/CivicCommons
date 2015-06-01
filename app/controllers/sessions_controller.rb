class SessionsController < Devise::SessionsController
  layout 'devise/sessions', only: [:new, :create, :ajax_new, :ajax_create]
  layout 'compact', only: [:new_compact, :create_compact]
  include RegionHelper

  prepend_before_filter :require_no_authentication, :only => [:new, :create, :ajax_new, :ajax_create, :new_compact, :create_compact]
  prepend_before_filter :allow_params_authentication!, :only => [:create, :ajax_create, :create_compact]
  before_filter :require_ssl, :only => [:new, :create, :new_compact, :create_compact]
  skip_before_filter :require_no_ssl
  after_filter :update_signin_cookie

  respond_to :json, only: [:status]

  def new
    super
    if RedirectHelper.valid?(request.headers['Referer'])
      session[:previous] = request.headers['Referer']
    end
  end

  def create
    super
    session[:previous] = nil
    default_region(current_person.default_region)
  end

  def ajax_new
    session[:close_modal_on_exit] = true
    session[:previous] = request.headers['Referer'] if RedirectHelper.valid?(request.headers['Referer'])
    render :partial => 'sessions/new', :layout => false
  end

  def status
    @person = current_person
  end

  # POST /resource/ajax_login
  def ajax_create
    Rails.logger.info 'ajax create'
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    sign_in(resource_name, resource)
    if session.has_key?(:close_modal_on_exit) and session[:close_modal_on_exit]
      @notice = "You have successfully logged in."
      respond_to do |format|
        format.js {render :partial => 'sessions/close_modal_on_exit', :layout => false}
        format.html do
          redirect_to session[:previous] || root_path
          session[:previous] = nil
        end
      end
    else
      render :action => :new
    end
  end

  def new_compact
    resource = build_resource
    clean_up_passwords(resource)
    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new_compact }
  end

  def create_compact
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new_compact")
    sign_in(resource_name, resource)
    redirect_to people_login_compact_path
  end

end
