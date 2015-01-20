# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :rating do |f|
    f.association :rating_descriptor, :factory => :rating_descriptor
    f.association :rating_group, :factory => :rating_group
  end
end