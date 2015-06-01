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

    def require_user
      if current_person.nil?
        return false
      else
        return true
      end
    end

    protected
    def render_404
      respond_to do |f|
        f.html { render 'private_labels/shared/404', status: 404 }
      end
    end

  end
end
