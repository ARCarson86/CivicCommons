require File.expand_path('./config/initializers/civic_commons.rb')

Civiccommons::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

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

  config.active_support.deprecation = :log

  # For devise gem
  config.action_mailer.default_url_options = { :host => Civiccommons::Config.devise['mailer_host'] }

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Choose the compressors to use
  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :yui

  # fallback to assets pipeline if a precompiled asset is missed
  # must be set to true, because there is bug in rails 3.1.0 http://stackoverflow.com/questions/7252872/upgrade-to-rails-3-1-0-from-rc6-asset-precompile-fails
  config.assets.compile = true

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w( admin.js ie7_jsIE9.js ie7_js/ie7-recalc.js show_colorbox.js conversations/activities.embed.js conversations/show_embed.js tiny_mce/**/*.js tiny_mce/*.js )
  config.assets.precompile += %w( admin.css widget.css tiny_mce/**/*.css)
  config.assets.precompile += Ckeditor.assets

  # parse the memcached.yml
  #memcached_config = YAML.load_file(Rails.root.join('config/memcached.yml'))
  #memcached_hosts = memcached_config['defaults']['servers']
  # # pass the servers to dalli setup
  #config.cache_store = :dalli_store, *memcached_hosts

end
