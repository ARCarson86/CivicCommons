FactoryGirl.define do
  factory :metro_region do
    city_name         { Faker::Address.city }
    display_name      { "#{city_name}-#{Faker::Address.state_abbr}" }
    metro_name        { display_name }
    metrocode         { Faker::Number.between(0,5) }
    province          { Faker::Address.state }
    province_code     { "#{city_name.downcase}-#{province.downcase}" }

    factory :default_metro_region do
      metrocode       "510"
    end
  end
end
