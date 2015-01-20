FactoryGirl.define do |f|
  factory :private_label do |pl|
    pl.name Faker::Company.name
    pl.namespace Faker::Internet.slug
    pl.domain Faker::Internet.domain_name
  end
end
