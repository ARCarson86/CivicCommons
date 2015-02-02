FactoryGirl.define do
  factory :action do |f|
    f.association :actionable, :factory => :petition
    f.association :conversation
  end
end