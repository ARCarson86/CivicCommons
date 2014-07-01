class PersonalSetting < ActiveRecord::Base
  belongs_to :person

  attr_accessible :tag_notification,
  								:notification_frequency

  validates_inclusion_of :notification_frequency, :in => %w(realtime daily weekly never), :message => "not a valid option"

end
