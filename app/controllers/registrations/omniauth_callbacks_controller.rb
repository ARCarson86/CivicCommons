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
      send_person_data_to_the_opening_window(person, registrations_principles_path)
    else
      flash[:email] = person.email
      render_js_registering_email_taken
    end
  end

  def we_came_from_the_registration_page? request
     request.env['omniauth.origin'] == new_person_registration_url or request.env['omniauth.origin'] == person_registration_url
  end

  def failed_linked_to_facebook
    flash[:notice] = I18n.t "devise.omniauth_callbacks.linked_failure", :kind => "Facebook"
    render_js_redirect_to(env['omniauth.origin'] || root_path)
  end

  def link_with_social
    authentication = Authentication.new_from_auth_hash(env['omniauth.auth'])
    provider = authentication.provider

    if current_person.link_with_social(authentication, provider)
      @other_email = Authentication.email_from_auth_hash(env['omniauth.auth'])

      sign_in current_person, :event => :authentication, :bypass => true
      if current_person.conflicting_email?(@other_email)
        successfully_linked_but_conflicting_email
      else
        flash[:notice] = I18n.t "devise.omniauth_callbacks.linked_success", :kind => "#{provider}"
        redirect_to edit_user_path(current_person)
      end
    else
      flash[:notice] = I18n.t "devise.omniauth_callbacks.linked_failure", :kind => "#{provider}"
        redirect_to edit_user_path(current_person)
    end
  end

  def successfully_linked_but_conflicting_email
    session[:other_email] = @other_email
    render_js_conflicting_email
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

  def render_js_registering_email_taken(options={})
    options[:path] = registering_email_taken_path
    render_js_colorbox(options)
  end

  def render_js_conflicting_email(options={})
    options[:path] = conflicting_email_path
    render_js_colorbox(options)
  end

  def render_js_colorbox(options={})
    @text = options.delete(:text) || 'Redirecting back to CivicCommons....'
    @path = options.delete(:path)
    @script = "
      #{isUnsafeJSPopup}
      if(window.opener) {
        if(isUnsafeJSPopup() != true){
          window.opener.$.colorbox({href:'#{@path}',opacity:0.5, onComplete: function(){
            window.close();
          }});
        }else{
          window.close();
        }
      }"
    render_popup(@text, @script)
  end

  def render_js_redirect_to(path = '', options={})
    @text = options.delete(:text) || 'Redirecting back to CivicCommons....'
    @script = isUnsafeJSPopup
    @script += "
      if(window.opener) {
        console.log('window.opener');
        if(isUnsafeJSPopup() != true){
          window.opener.onunload = function(){
              window.close();
          };
          window.opener.location = '#{path}';
        }else{
          window.opener.location = '#{path}';
          window.close();
        }
      }"
   render_popup(@text, @script)
  end

  def isUnsafeJSPopup
    #used to see if it's cross domain or not
    "isUnsafeJSPopup = function(){
      var cross_domain = false;
      try{
        cross_domain = window.opener.location.protocol != window.location.protocol;
      } catch(e){
        cross_domain = true;
      }
      return cross_domain;
    }"
  end

  def render_popup(text,script = nil)
    render :partial => '/authentication/fb_interstitial_message', :layout => 'fb_popup', :locals => {:text => text, :script => script}
  end

  def send_person_data_to_the_opening_window(person, redirect_path)
    render :partial => '/plain_old_javascript', locals: {
      script: "window.opener.OmniAuthHandler.handleAccountCreation(#{person.to_json(:include=>:authentications)}, '#{redirect_path}')" }
  end
end
