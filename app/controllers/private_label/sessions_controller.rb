class PrivateLabel::SessionsController < Devise::SessionsController
  include PrivateLabelControllerConcern

  def new
    if authentication = Authentication.find_from_auth_hash(params["authentication"])
      unless authentication.person.blank?
        authentication.person.remember_me = true
        sign_in authentication.person, :event => :authentication
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "#{authentication.provider}"
        redirect_to root_path, :kind => "#{authentication.provider}"
      end
    else
      super
    end
  end
end
