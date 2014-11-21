class PrivateLabel::ApplicationController < ActionController::Base
	before_filter :enable_swayze

	protected
	def enable_swayze
    domain = request.subdomains.first
    @swayze = Swayze.new(domain)
  end
end