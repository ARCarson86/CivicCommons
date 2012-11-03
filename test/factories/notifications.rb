FactoryGirl.define do
  factory :notification do |f|
    f.association :person, :factory => :registered_user
    f.association :receiver, :factory => :registered_user
    f.association :item, :factory => :conversation
    f.item_created_at "2010-06-30 12:39:43"
  end
end
