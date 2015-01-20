FactoryGirl.define do
  factory :topic do
    sequence(:name)     { |n| "#{Faker::Commerce.department(1)} #{n}" }
  end
end
