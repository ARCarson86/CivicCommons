# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :conversation_subscription, :class => Subscription do |f|
    f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
    f.association :subscribable, :factory => :conversation, :title => 'The Civic Commons'
  end

  factory :issue_subscription, :class => Subscription do |f|
    f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
    f.association :subscribable, :factory => :issue, :summary => 'The Civic Commons'
  end

  factory :organization_subscription, :class => Subscription do |f|
    f.association :person, :factory => :registered_user, :first_name => 'Marc', :last_name => 'Canter'
    f.association :subscribable, :factory => :organization
  end
end

