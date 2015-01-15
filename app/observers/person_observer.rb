class PersonObserver < ActiveRecord::Observer


  def after_save(person)
    AvatarService.update_avatar_url_for(person)
    person.send_welcome_email if person.send_welcome?
    person.update_newsletter_subscription person.weekly_newsletter_changed?
  end

  def after_create(person)
    person.notify_civic_commons
    person.update_newsletter_subscription true
  end

end
