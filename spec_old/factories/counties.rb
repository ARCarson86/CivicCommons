# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :county do |f|
    f.name "MyString"
    f.state "MyString"
  end
end