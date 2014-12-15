class PrivateLabel::PlController < ActionController::Base
	before_filter :enable_swayze

	layout 'private_label/layouts/application'

	protected
	def enable_swayze
    domain = request.subdomains.first
    @swayze = ::Swayze.new(domain)
  end
end