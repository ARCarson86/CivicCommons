require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require "steak"

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Put your page object inside /spec/acceptance/pages
Dir["#{File.dirname(__FILE__)}/pages/**/*.rb"].each {|f| require f}

WebMock.allow_net_connect!
Capybara.default_wait_time = 10
require 'acceptance/steps'

module Rack
  module Utils
    def escape(s)
      CGI.escape(s.to_s)
    end
    def unescape(s)
      CGI.unescape(s)
    end
  end
end
