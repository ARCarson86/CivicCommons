# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :visit do |f|
    f.association :person, :factory => :normal_person
  end
end