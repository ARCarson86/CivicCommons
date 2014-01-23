source 'https://rubygems.org'

gem 'rails', '~> 3.2.16'

gem 'mysql2'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "font-awesome-rails"
end

gem 'jquery-rails'

gem 'newrelic_rpm'

gem 'dalli'
gem 'cache_digests', :git => 'git://github.com/CivicCommons/cache_digests.git', :branch  => "master"

gem 'devise', '1.5.2'
gem "cancan", '1.6.8'
gem 'omniauth', '1.0.1'
gem 'omniauth-facebook'

gem 'fb_graph'

gem 'json', '~>1.7.7'

gem 'haml', '~> 4.0.3'

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

gem 'airbrake'

gem 'remotipart'

# gem 'paperclip', "~>2.5.0"
gem 'paperclip', '~> 3.1'
gem 'delayed_paperclip'
gem 'aws-s3'
gem 'aws-sdk'
gem 'nokogiri'
gem 'sanitize'
gem 'highline'
gem 'htmlentities'
gem 'truncate_html'

gem "gchart", "~> 1.0.0"

gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'progress_bar'

gem 'fitter-happier', '= 0.0.1'

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

group :development do
  gem "rails3-generators"
  gem "hpricot"
  gem "ruby_parser"
  gem "engineyard"
  gem 'rails-dev-tweaks'
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
  gem 'webmock', '~>1.6.2' #, :git => 'git://github.com/CivicCommons/webmock.git', :branch => '1.6.2'
  gem 'webrat', "~> 0.7.3"
end


group :cool_toys do
  gem 'autotest'
  gem 'autotest-rails'
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem 'query_reviewer', :git => 'git://github.com/nesquena/query_reviewer.git'
  gem 'launchy'
end

