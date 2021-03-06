ENV["RAILS_ENV"] ||= 'test'

require 'rubygems'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'
require 'webmock/rspec'
require 'aws-sdk'
require 'capybara/rspec'
require 'email_spec'
require 'paperclip/matchers'
require 'pp'
require 'database_cleaner'

if ENV['COVERAGE'] #$ COVERAGE=true RAILS_ENV=test bundle exec rake spec
  require 'simplecov'
  SimpleCov.start do
    add_filter '/autotest/'
    add_filter '/config/'
    add_filter '/db/'
    add_filter '/deploy/'
    add_filter '/doc/'
    add_filter '/features/'
    add_filter '/lib/jobs/'
    add_filter '/lib/tasks/'
    add_filter '/log/'
    add_filter '/public/'
    add_filter '/script/'
    add_filter '/spec/'
    add_filter '/test/'
    add_filter '/tmp/'
    add_filter '/vendor/'
    add_group 'Concerns', 'app/concerns'
    add_group 'Controllers', 'app/controllers'
    add_group 'Helpers', 'app/helpers'
    add_group 'Libraries', 'lib'
    add_group 'Mailers', 'app/mailers'
    add_group 'Models', 'app/models'
    add_group 'Observers', 'app/observers'
    add_group 'Services', 'app/services'
    add_group 'Presenters', 'app/presenters'
    #add_group 'Views', 'app/views'
  end
end


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include CustomMatchers
  config.include WebMock::API
  config.include StubbedHttpRequests
  config.include Paperclip::Shoulda::Matchers
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view
  config.include Rails.application.routes.url_helpers

  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false

  config.before :suite do
    ActiveRecord::Base.observers.disable :all
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
    Capybara.javascript_driver = :selenium
  end

  config.before :each do
    default_url_options[:host] = 'test.host'
    DatabaseCleaner.start
    stub_contribution_urls
    stub_amazon_s3_request
    stub_pro_embedly_request
    stub_gravatar
    ActionMailer::Base.deliveries.clear
  end
  config.filter_run_excluding :wip=>true unless ENV['WIP']
  config.after :each do
    DatabaseCleaner.clean
  end
end

# figure out where we are being loaded from
if $LOADED_FEATURES.grep(/spec\/spec_helper\.rb/).any?
  begin
    raise "foo"
  rescue => e
    puts <<-MSG
  ===================================================
  It looks like spec_helper.rb has been loaded
  multiple times. Normalize the require to:

    require "spec/spec_helper"

  Things like File.join and File.expand_path will
  cause it to be loaded multiple times.

  Loaded this time from:

    #{e.backtrace.join("\n    ")}
  ===================================================
    MSG
  end
end
