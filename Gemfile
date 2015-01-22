source 'https://rubygems.org'

gem 'unicorn'

gem 'rails', '~> 3.2.16'

gem 'mysql2'

gem 'uglifier'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails'
  gem 'yui-compressor'
  gem "font-awesome-rails"
  gem 'turbo-sprockets-rails3'
end
gem 'jquery-rails'

gem 'newrelic_rpm'

gem 'redis-rails'

gem 'devise', '1.5.2'
gem "cancan"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin'

gem 'fb_graph'

gem 'json', '~>1.7.7'

gem 'date_validator'
gem "will_paginate"

gem 'httparty'

gem 'geokit'

gem "friendly_id"
gem 'acts_as_revisionable'
gem 'awesome_nested_set'
gem 'embedly', '1.5.2'

gem 'gibbon'
gem 'hominid', "~>3.0.2"
gem 'delayed_job', ">= 2.1.2"
gem 'delayed_job_active_record'
gem 'daemons'

gem 'remotipart'

# gem 'paperclip', "~>2.5.0"
gem 'paperclip'
gem 'aws-s3'
gem 'aws-sdk', "~> 1.9.1"
gem 'nokogiri'
gem 'sanitize'
gem 'highline'
gem 'htmlentities'
gem 'truncate_html'
gem 'obscenity'

gem "gchart"

gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar'

gem 'sixarm_ruby_email_address_validation'

gem 'ckeditor'

gem 'prawn_rails'
gem 'prawn', '>= 1.0.0.rc1'

gem 'fog'
gem 'carrierwave'
gem 'mini_magick'

gem 'rails_autolink' # auto_link was removed on rails 3.1, this is for migration purposes. A suggestion is to use Rinku
gem 'sass'

gem 'whenever', require: false

gem 'jbuilder'
gem 'jpbuilder'

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-debugger'
  gem 'faker'
end

group :development do
  gem "letter_opener"
  gem "foreman"
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Addressable Required by WebMock but breaks everything at 2.2.5
  # Can use latest addressable when pull request is accepted: https://github.com/sporkmonger/addressable/pull/33
  gem "rspec-rails"
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem 'timecop'
  gem 'webmock'
end
