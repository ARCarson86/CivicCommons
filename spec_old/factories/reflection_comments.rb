# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :reflection_comment do |f|
    f.body 'Body comment here'
    f.association(:person)
    f.association(:reflection)
  end
end