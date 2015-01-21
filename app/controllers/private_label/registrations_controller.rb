class PrivateLabel::RegistrationsController < Devise::RegistrationsController
  include PrivateLabelControllerConcern

  before_filter :omniauth_registration, only: [:new]

  def new
    resource = @person || build_resource({})
    respond_with_navigational(resource){ render_with_scope :new }
  end

  def create
    if params['person'].has_key?('authentications_attributes')
      params['person']['create_from_auth'] = true
      params['person']['confirmed_at'] = DateTime.now
    end

    if @authentication.present?
      @authentication.save!
    end

    unless params[:agree_to_terms]
      flash[:notice] = "Please agree to the terms"
      build_resource params[:person]
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render_with_scope :new }
    else
      super
    end

    if params[:agree_to_terms]
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{authentication.provider}"
      @swayze.private_label.people << resource
    end
  end

  def present_terms
    redirect_to new_person_registration_path unless current_person
  end

  def agree_to_terms
    if current_person and params[:agree_to_terms]
      redirect_to registrations_agree_to_terms_path unless params[:agree_to_terms]
      @swayze.private_label.people << current_person
      flash[:notice] = "Thank you for agreeing to the terms"
      redirect_to root_url
    else
      redirect_to new_person_registration_path
    end
  end

  protected

  def omniauth_registration
    return unless params[:authentication_id]
    if Rails.cache.exist? [:omniauth, :auth, params[:authentication_id]]
      omniauth_auth = Rails.cache.read [:omniauth, :auth, params[:authentication_id]]
      Rails.cache.delete [:omniauth, :auth, params[:authentication_id]] #TODO uncomment this line for production
      if authentication = Authentication.find_from_auth_hash(omniauth_auth)
        if authentication.person.present?
          authentication.person.remember_me = true
          sign_in authentication.person, :event => :authentication
          flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{authentication.provider}"
          redirect_to after_sign_in_path_for(authentication.person), :kind => "#{authentication.provider}"
        end
      else
        provider = omniauth_auth[:provider]
        @person = Person.build_from_auth_hash(omniauth_auth)
        @person.authentications.new_from_auth_hash(omniauth_auth)
      end
    else
      flash[:notice] = "There was a problem signing you in"
      return
    end
  end

end
