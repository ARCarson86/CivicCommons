FactoryGirl.define do
  factory :invite do |f|
    f.source_id 123
    f.source_type 'conversations'
    f.association :user, :factory => :normal_person
    f.emails "abc@test.com 123@test.com, aaa@test.com"
  end
end