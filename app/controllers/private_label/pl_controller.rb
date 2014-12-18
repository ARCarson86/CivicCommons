class PrivateLabel::PlController < ActionController::Base
	before_filter :enable_swayze

	alias_method :current_user, :current_person

	layout 'private_label/layouts/application'

	protected
	def enable_swayze
    domain = request.subdomains.first
    @swayze = ::Swayze.new(domain)
  end
end