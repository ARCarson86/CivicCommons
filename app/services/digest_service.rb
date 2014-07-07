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
    @digest_recipients = Person.where(subscriptions_setting: @interval).joins(:notifications).group('person_id').having('COUNT(*) >?', 0)
  end

  def get_notifications
    @digest_recipients.each do |recipient|
      @notifications = recipient.notifications.where(emailed: nil).order(:conversation_id)
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