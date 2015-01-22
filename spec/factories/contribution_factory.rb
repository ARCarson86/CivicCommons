FactoryGirl.define do
  factory :contribution do
    top_level             false
    parent                nil
    content               { Faker::Lorem.paragraph }
    override_confirmed    true
    url                   nil

    conversation
    person

    factory :top_level_contribution do
      top_level           true
    end

    factory :unconfirmed_contribution do
      override_confirmed  false
    end
  end
end

