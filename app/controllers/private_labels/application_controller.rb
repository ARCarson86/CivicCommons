module PrivateLabels
  class ApplicationController < ActionController::Base
    include PrivateLabelControllerConcern

    # Rescue from routing error
    rescue_from ActionController::RoutingError do |exception|
      raise if ["development", "test"].include? ENV["RAILS_ENV"]
      render_404
    end

    def raise_routing_error
      raise ActionController::RoutingError.new "No route matches [#{request.method}] #{request.path.inspect}"
    end

    protected
    def render_404
      respond_to do |f|
        f.html { render 'private_label/pl/404', status: 404 }
      end
    end

  end
end # PrivateLabels module