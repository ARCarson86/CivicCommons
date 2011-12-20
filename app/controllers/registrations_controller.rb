class RegistrationsController < Devise::RegistrationsController

  before_filter :require_ssl

  helper_method :form_presenter

  def create
    params['person']['create_from_auth'] = true
    params['person']['encrypted_password'] = ''
    super
  end

  def after_inactive_sign_up_path_for(resource)
    url_for :new_person_confirmation
  end

  def form_presenter
    @presenter = RegistrationFormPresenter.new(resource)
  end

  def principles
    
  end

  def new_organization
    # taken from devise's registration_controller#new
    resource = build_resource
    respond_with_navigational(resource){ render_with_scope :new_organization }
  end

  def create_organization
    # taken from devise's registration_controller#create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new_organization }
    end
  end

end
