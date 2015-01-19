FactoryGirl.define do
  factory :email_restriction do |f|
    f.sequence(:domain) {|n| "test#{n}.com" }
  end
end