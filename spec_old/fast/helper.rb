$LOAD_PATH << "."
require 'rspec-spies'
unless defined? Rails
  class Rails

    def self.application
      Application.new
    end
    class Application
      def routes
        Routes.new
      end
    end

    class Routes
      def url_helpers
        Fake
      end
    end
  end

  module Fake
  end
  class Object
    def present?
      !empty?
    end
  end
end
