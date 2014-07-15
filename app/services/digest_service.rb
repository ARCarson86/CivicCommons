class DigestService

  attr_reader :digest_recipients,
              :digest_set,
              :updated_contributions,
              :updated_conversations,
              :votes_created_activities,
              :votes_ended_activities,
              :vote_response_activities,
              :new_petitions,
              :petition_signatures_activity,
              :grouped_petition_signatures_activity

  def initialize(interval)
    @interval = interval
  end

  def generate_digest_set
    get_digest_recipients
    get_notifications
  end

  def get_digest_recipients
    @digest_recipients = Person.select("people.*, COUNT(notifications.id) notification_count").where(subscriptions_setting: @interval).joins("INNER JOIN notifications ON receiver_id=people.id AND notifications.emailed IS NULL").group('receiver_id').having('notification_count >?', 0)
  end

  def get_notifications
    @digest_recipients.each do |recipient|
      @notifications = recipient.get_notifications
      @conversations = Conversation.where(id: @notifications.pluck(:conversation_id).uniq)
      Notifier.daily_digest(recipient, @notifications, @conversations).deliver unless @notifications.blank?
      @notifications.update_all(emailed: DateTime.now)
    end
  end

  def self.send_digest(interval)
    digest = self.new(interval)
    digest.generate_digest_set
  end
end