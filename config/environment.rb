# Load the rails application
require File.expand_path('../application', __FILE__)
gem 'devise'

# Initialize the rails application
Civiccommons::Application.initialize!

Time::DATE_FORMATS[:yyyymmdd] = "%Y.%m.%d"
