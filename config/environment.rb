# Load the rails application
require File.expand_path('../application', __FILE__)
gem 'devise'

# Initialize the rails application
Civiccommons::Application.initialize!

Dir["#{Rails.root}/app/models/*"].find_all { |f| File.stat(f).directory? }.collect{ |f| ActiveSupport::Dependencies.autoload_paths << f }

Time::DATE_FORMATS[:yyyymmdd] = "%Y.%m.%d"
