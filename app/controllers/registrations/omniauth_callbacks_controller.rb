class Registrations::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :require_no_ssl

  def social(provider)
    if signed_in? && !current_person.social_authenticated?(provider)
      link_with_social
    else
      if authentication = Authentication.find_from_auth_hash(env['omniauth.auth'])
        successful_authentication(authentication)
      else
        create_account_using_social_credentials
      end
    end
  end

  def twitter
    social("twitter")
  end

  def facebook
    social("facebook")
  end

  def linkedin
    social("linkedin")
  end

  def google_oauth2
    social("google_oauth2")
  end

  def failure
    text = "#{I18n.t('devise.omniauth_callbacks.failure', :kind => failed_strategy.name.to_s.humanize, :reason => failure_message)}"
    render_popup(text)
  end

private
  def auth_popup?
    params[:auth_popup] && params[:auth_popup] == true
  end

  def create_account_using_social_credentials
    person = Person.build_from_auth_hash(env['omniauth.auth'])
    if Person.where(email: person.email).size == 0
      provider = (env['omniauth.auth'])[:provider]
      flash[:notice] = "Your #{provider} account is not connected to your login. Select another login method and connect #{provider} account."
      redirect_to new_person_session_path
    else
      flash[:email] = person.email
    end
  end

  def we_came_from_the_registration_page? request
     request.env['omniauth.origin'] == new_person_registration_url or request.env['omniauth.origin'] == person_registration_url
  end

  def link_with_social
    authentication = Authentication.new_from_auth_hash(env['omniauth.auth'])
    provider = authentication.provider

    if current_person.link_with_social(authentication, provider)
      @other_email = Authentication.email_from_auth_hash(env['omniauth.auth'])
      if provider == "twitter"
        current_person.twitter_username = request.env['omniauth.auth'].info[:nickname]
        current_person.save
      end

      sign_in current_person, :event => :authentication, :bypass => true
      flash[:notice] = I18n.t "devise.omniauth_callbacks.linked_success", :kind => "#{provider}"
      redirect_to edit_user_path(current_person)
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.linked_failure", :kind => "#{provider}"
        redirect_to edit_user_path(current_person)
    end
  end

  def successful_authentication(authentication)
    unless authentication.person.blank?
      authentication.person.remember_me = true
      sign_in authentication.person, :event => :authentication
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{authentication.provider}"
      redirect_to root_path, :kind => "#{authentication.provider}"
    else
      create_account_using_social_credentials
    end
  end
end
