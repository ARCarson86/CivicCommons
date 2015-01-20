# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spec_helper'
require 'webmock/rspec'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Add the Devise test helpers
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :helper

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Add the FactoryGirl methods as first-class citizens
  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  ##
  # For integration tests (i.e., run by Capybara), use
  # a different strategy because that will be run in a 
  # different process.  Can't use transaction in that 
  # case.
  config.before type: :request do
    DatabaseCleaner.strategy = :truncation
  end

  config.after type: :request do
    DatabaseCleaner.strategy = :transaction
  end

  config.before :each do
    ActiveRecord::Base.observers.disable :all
    DatabaseCleaner.start
    ActionMailer::Base.deliveries.clear
    WebMock.disable_net_connect!
    stub_request(:post, "http://localhost:8981/solr/update?wt=ruby").to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get, /http:\/\/gravatar\.com\/avatar.*/).to_return(body: '', status: 404)
  end

  config.after :each do
    ActiveRecord::Base.observers.enable :all
    DatabaseCleaner.clean
  end
end
