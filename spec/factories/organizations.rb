FactoryGirl.define do |f|
  factory :organization, :class => Organization do |o|
    o.name 'The Civic Commons'
    o.sequence(:email) {|i| "us#{i}@theciviccommons.com"}
    o.password 'password'
    o.zip_code '44115'
    o.website "http://theciviccommons.com"
    o.twitter_username 'theciviccommons'
    o.association :organization_detail
    o.after(:create) { |oo| oo.authorized_to_setup_an_account = true }
  end
  factory :newly_confirmed_organization, :parent => :organization do |o|
    o.confirmed_at { Time.now }
  end
end