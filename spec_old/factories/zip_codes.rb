# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :zip_code do |f|
    f.association :region, :factory => :region
    f.zip_code "11111"
  end
end