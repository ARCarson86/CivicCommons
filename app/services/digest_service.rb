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

  def initialize
    @digest_set = { }
  end

  #TODO: Make a class for the digest data and return an array of that class
  #TODO: Use 'letter' param to segment the data set by first letter of last name
  #TODO: Optimize the data retrieval
  def generate_digest_set(letter = nil)
    get_digest_recipients
    get_notifications
  end

  def process_daily_digest(set = nil)

    # get the set of people receiving the digest email
    set = self.generate_digest_set if set.nil?
    # for each person
    set.each do |person, conversations|

      unless set[person].empty?
        # send the email
        Notifier.daily_digest(person, conversations).deliver
      end

    end

  end

  def get_digest_recipients(interval)
    @digest_recipients = Person.where(subscriptions_setting: interval).joins(:notifications).includes(:notifications).group('person_id').having('COUNT(*) >?', 0)
  end

  def get_notifications
    @digest_recipients.each do |recipient|
      recipient.notifications
    end
  end

  #TODO: Use 'letter' param to segment the data set by first letter of last name
  def self.send_digest(letter = nil, set = nil)
    digest = self.new
    digest.generate_digest_set(letter)
    digest.process_daily_digest(set)
  end

end
