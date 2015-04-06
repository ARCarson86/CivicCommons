require File.expand_path('./config/initializers/civic_commons.rb')
require File.expand_path('./lib/mail_interceptor.rb')

Civiccommons::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  config.assets.initialize_on_precompile = true

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # DO care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  ActionMailer::Base.smtp_settings = {
    :address              => Civiccommons::Config.smtp['address'],
    :domain               => Civiccommons::Config.smtp['domain'],
    :user_name            => Civiccommons::Config.smtp['username'],
    :password             => Civiccommons::Config.smtp['password'],
    :authentication       => "plain",
    :enable_starttls_auto => true
  }

  ActionMailer::Base.register_interceptor(MailInterceptor)

  config.active_support.deprecation = :log

  # For devise gem
  config.action_mailer.default_url_options = { :host => Civiccommons::Config.devise['mailer_host'] }

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  #config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # fallback to assets pipeline if a precompiled asset is missed
  # must be set to true, because there is bug in rails 3.1.0 http://stackoverflow.com/questions/7252872/upgrade-to-rails-3-1-0-from-rc6-asset-precompile-fails
  config.assets.compile = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  config.assets.precompile = [ Proc.new{ |path| !File.extname(path).in?(['.js', '.css', '.map', '.gzip']) }, /(?:\/|\\|\A)application\.(css|js)$/ ]

  config.assets.precompile << %w( admin.js conversations/activities.embed.js conversations/show_embed.js private_label/application.js )
  config.assets.precompile << %w( reset.css master.css ie.css petition.print.css admin.css widget.css _bootstrap.css)

  config.assets.precompile << "tinymce/themes/advanced/skins/private_label/*.css"

  config.angular_templates.ignore_prefix = ['embed/ng/templates/', 'templates'] if config.angular_templates

  redis_config = YAML.load_file(Rails.root.join('config/redis.yml'))
  config.cache_store = :redis_store, "redis://#{redis_config[Rails.env]["host"]}:#{redis_config[Rails.env]["port"]}/0/cache", {expires_in: 7.days }

end
