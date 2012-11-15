class NotificationObserver < ActiveRecord::Observer

  observe :contribution, :conversation, :rating_group, :survey_response,
          :petition, :petition_signature, :reflection, :reflection_comment, :survey

  def after_create(model)
    unless model.is_a?(Contribution) && model.unconfirmed?
      Notification.create_for(model)
    end
  end
  
  def before_update(model)
    if model.is_a?(Contribution) && model.confirmed_changed? && model.confirmed?
      Notification.create_for(model)
    end
  end

  def before_destroy(model)
    Notification.destroy_for(model)
  end

end
