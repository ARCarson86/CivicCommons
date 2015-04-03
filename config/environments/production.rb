require File.expand_path('./config/initializers/civic_commons.rb')

Civiccommons::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb
  config.assets.initialize_on_precompile = true

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  # config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
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

  config.active_support.deprecation = :log

  # For devise gem
  config.action_mailer.default_url_options = { :host => Civiccommons::Config.devise['mailer_host'] }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # fallback to assets pipeline if a precompiled asset is missed
  # must be set to true, because there is bug in rails 3.1.0 http://stackoverflow.com/questions/7252872/upgrade-to-rails-3-1-0-from-rc6-asset-precompile-fails
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  config.assets.precompile = [ Proc.new{ |path| !File.extname(path).in?(['.js', '.css', '.map', '.gzip']) }, /(?:\/|\\|\A)application\.(css|js)$/ ]

  config.assets.precompile << %w( admin.js conversations/activities.embed.js conversations/show_embed.js tiny_mce/**/*.js tiny_mce/*.js )
  config.assets.precompile << %w( reset.css master.css ie.css petition.print.css admin.css widget.css tiny_mce/**/*.css)

  config.angular_templates.ignore_prefix = ['embed/ng/templates/', 'templates'] if config.angular_templates

  if (File.exist? Rails.root.join('config/redis.yml'))
    redis_config = YAML.load_file(Rails.root.join('config/redis.yml'))
    config.cache_store = :redis_store, "redis://#{redis_config[Rails.env]["host"]}:#{redis_config[Rails.env]["port"]}/0/cache", {expires_in: 7.days }
  end

end
