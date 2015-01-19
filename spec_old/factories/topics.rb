FactoryGirl.define do
  factory :topic do |f|
    f.sequence(:name) {|n| "Topic #{n}" }
  end
end