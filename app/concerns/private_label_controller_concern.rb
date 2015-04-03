module PrivateLabelControllerConcern
  extend ActiveSupport::Concern

  included do
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

  def tos_path_if_unauthorized(resource)
    enable_swayze unless Swayze.current_private_label.present?
    registrations_agree_to_terms_path unless Swayze.current_private_label.people.first conditions: { id: resource.id }
  end

end
