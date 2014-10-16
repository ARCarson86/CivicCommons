FactoryGirl.define do
  factory :topic do |f|
    f.name { Faker::Lorem.word }
  end
end
