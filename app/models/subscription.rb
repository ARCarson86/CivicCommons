class Subscription < ActiveRecord::Base
  belongs_to :subscribable, :polymorphic => true
  belongs_to :person

  scope :conversations, where(subscribable_type: 'Conversation')
  scope :issues,        where(subscribable_type: 'Issue')
  scope :organizations, where(subscribable_type: 'Organization')

  delegate :name, :to => :person, :prefix => true
  delegate :title, :to => :subscribable

  def self.subscribable?(subscription_type, subscription_id=nil, subscriber=nil)
    subscribable_model = subscription_type.camelize.constantize
    return subscribable_model.include? Subscribable
  end

  def self.subscribe(subscription_type, subscription_id, subscriber)
    if self.subscribable?(subscription_type)
      subscribable_model = subscription_type.camelize.constantize
      subscribable_model.find(subscription_id).subscribe(subscriber)
    else
      raise(ArgumentError, "Invalid attempt made to subscribe to:#{subscription_type}. #{subscription_type} must implement subscribable.")
    end
  end

  def self.unsubscribe(subscription_type, subscription_id, subscriber)
    if self.subscribable?(subscription_type)
      subscribable_model = subscription_type.camelize.constantize
      subscribable_model.find(subscription_id).unsubscribe(subscriber)
    else
      raise(ArgumentError, "#{model}'s can not be subscribed to.")
    end
  end

  def self.create_unless_exists(person, subscribable)
    unless person.subscriptions.collect{|sub| sub.subscribable}.include?(subscribable)
      person.subscriptions.create(subscribable: subscribable)
    end
  end
end
