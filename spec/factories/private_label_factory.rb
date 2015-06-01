FactoryGirl.define do
  factory :private_label do
    name        { Faker::Company.name }
    domain      { Faker::Internet.domain_name }
    namespace   { Faker::Internet.domain_name }
    email       { Faker::Internet.email }
  end
end
