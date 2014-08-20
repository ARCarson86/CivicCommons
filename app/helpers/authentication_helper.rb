module AuthenticationHelper

  # uses url instead of path if https
  def person_omniauth_authorize_path_or_url(provider)
    SecureUrlHelper.https? ? person_omniauth_authorize_url(provider, :protocol => 'https') : person_omniauth_authorize_path(provider)
  end

  def person_omniauth_authorize_url(provider, params = {})
    if Devise.omniauth_configs[provider.to_sym]
      "#{root_url(:protocol => params.delete(:protocol))}people/auth/#{provider}#{'?'+params.to_param if params.present?}"
    else
      raise ArgumentError, "Could not find omniauth provider #{provider.inspect}"
    end
  end
end
