FactoryGirl.define do
  factory :activity do |activity|
    activity.item_type 'Conversation'
    activity.item_created_at Time.now
    activity.association :person, :factory => :normal_person
  end

  factory :conversation_activity, parent: :activity do |activity|
    activity.item_type 'Conversation'
    activity.item_created_at Time.now
  end

  factory :contribution_activity, parent: :activity do |activity|
    activity.item_type 'Contribution'
    activity.item_created_at Time.now
  end

  factory :rating_group_activity, parent: :activity do |activity|
    activity.item_type 'RatingGroup'
    activity.item_created_at Time.now
  end

  factory :survey_response_activity, parent: :activity do |activity|
    activity.item_type 'SurveyResponse'
    activity.item_created_at Time.now
  end

end


