class PrivateLabel::PlController < ActionController::Base
	before_filter :enable_swayze

	alias_method :current_user, :current_person

	layout 'private_label/layouts/application'

	protected
	def enable_swayze
    find_by = request.subdomains.length > 1 ? { namespace: request.subdomains.first } : { domain: request.host }
    @swayze = ::Swayze.new(find_by)
  end
end
