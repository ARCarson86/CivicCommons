# need to use full_host on engineyard due to problem: https://github.com/intridea/omniauth/issues/101
OmniAuth.config.full_host = Civiccommons::Config.omniauth['full_host'] if defined? Civiccommons::Config.omniauth
