FactoryGirl.define do
  factory :conversation do
    finished_at           ''
    from_community        false
    started_at            ''
    starter               { Faker::Lorem.sentence }
    summary               { Faker::Lorem.paragraph }
    zip_code              { Faker::Address.zip_code }
    title                 { Faker::Lorem.sentence[0..30] }

    association :metro_region, factory: :default_metro_region
    association :person, factory: :admin

    before(:create) do |conversation|
      conversation.topics << create(:topic)
    end
  end
end
