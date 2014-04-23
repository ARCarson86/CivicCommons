source 'https://rubygems.org'

gem 'rails', '~> 3.2.16'

gem 'mysql2'

gem 'sass-rails', '~> 3.2.3'
gem 'compass-rails'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'
gem "font-awesome-rails"

group :assets do
end

gem 'jquery-rails'

gem 'newrelic_rpm'

gem 'redis-rails'

gem 'devise', '1.5.2'
gem "cancan", '1.6.8'
gem 'omniauth', '1.0.1'
gem 'omniauth-facebook'

gem 'fb_graph'

gem 'json', '~>1.7.7'

gem 'date_validator'
gem "will_paginate", "~> 3.0.3"

gem 'httparty'

gem 'geokit'

gem "friendly_id", "~> 4.0.1"
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
gem 'paperclip', '~> 3.1'
gem 'aws-s3'
gem 'aws-sdk', "~> 1.9.1"
gem 'nokogiri'
gem 'sanitize'
gem 'highline'
gem 'htmlentities'
gem 'truncate_html'

gem "gchart", "~> 1.0.0"

gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar'

gem 'sixarm_ruby_email_address_validation'

gem 'profanity_filter', :git => 'git://github.com/CivicCommons/profanity_filter.git'

gem 'ckeditor', :git => 'git://github.com/paramaw/ckeditor.git', :branch  => "master" # a bug was introduced to 3.7.3 that made ckeditor unable to work with IE

gem 'prawn_rails'
gem 'prawn', '>= 1.0.0.rc1'

gem 'fog'
gem 'carrierwave'
gem 'mini_magick'

gem 'rails_autolink' # auto_link was removed on rails 3.1, this is for migration purposes. A suggestion is to use Rinku
gem 'sass'

gem 'therubyracer'

gem 'whenever', require: false

group :development do
  gem "rails3-generators"
  gem "hpricot"
  gem "ruby_parser"
  gem "zeus"
end

group :test do
  # Addressable Required by WebMock but breaks everything at 2.2.5
  # Can use latest addressable when pull request is accepted: https://github.com/sporkmonger/addressable/pull/33
  gem 'shoulda'
  gem 'addressable'
  gem "capybara", '~> 1.1.2'
  gem "database_cleaner", "~>0.7.2"
  gem 'email_spec', '~>1.2.1'
  gem "factory_girl_rails", '~>3.1'
  gem 'fuubar', '~>1.0.0'
  gem "jasmine", "~> 1.3.1"
  gem "jasmine-headless-webkit", '~>0.8.4'
  gem 'linguistics', '~>1.0.9'
  gem 'no_peeping_toms', "~>2.1.2"
  gem "rack-test", '~> 0.6.0'
  gem "rspec-rails", "~> 2.10.0"
  gem 'rspec-spies', '~>2.1.0'
  gem 'simplecov', '~>0.6.2'
  gem 'spork', '~>0.9.0'
  gem 'steak', '~>2.0.0'
  gem 'timecop', '~>0.3.5'
  gem 'webmock'
  gem 'webrat', "~> 0.7.3"
end
