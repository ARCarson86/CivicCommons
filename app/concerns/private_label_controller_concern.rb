module PrivateLabelControllerConcern
  extend ActiveSupport::Concern

  included do
    before_filter :enable_swayze
    alias_method :current_user, :current_person
    layout 'private_labels/layouts/application'
  end

  def after_sign_in_path_for(resource)
    tos_path_if_unauthorized(resource) || stored_location_for(resource) || root_path
  end

  protected
	def enable_swayze
    find_by = request.subdomains.length > 1 ? { namespace: request.subdomains.first } : { domain: request.host }
    @swayze = ::Swayze.new(find_by)
  end

  def tos_path_if_unauthorized(resource)
    enable_swayze unless @swayze
    registrations_agree_to_terms_path unless @swayze.people.first conditions: { id: resource.id }
  end

end
