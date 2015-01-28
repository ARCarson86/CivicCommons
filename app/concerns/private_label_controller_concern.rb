module PrivateLabelControllerConcern
  extend ActiveSupport::Concern

  included do
    prepend_before_filter :enable_swayze
    alias_method :current_user, :current_person
    layout 'private_labels/layouts/application'
  end

  def after_sign_in_path_for(resource)
    tos_path_if_unauthorized(resource) || stored_location_for(resource) || root_path
  end

  def current_ability
    @current_ability ||= PrivateLabels::Ability.new(current_person)
  end

  protected

  def enable_swayze
    find_by = request.subdomains.length > 1 ? { namespace: request.subdomains.first } : { domain: request.host }
    private_label = PrivateLabel.first(conditions: find_by)
    if private_label.nil?
      raise ActiveRecord::RecordNotFound
    else
      Swayze.current_private_label = private_label
    end
  end

  def tos_path_if_unauthorized(resource)
    enable_swayze unless Swayze.current_private_label.present?
    registrations_agree_to_terms_path unless Swayze.current_private_label.people.first conditions: { id: resource.id }
  end

end
