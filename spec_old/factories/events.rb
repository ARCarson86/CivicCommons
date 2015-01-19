FactoryGirl.define do
  factory :event do |f|
    f.title "MyString"
    f.when "2010-07-15 15:22:25"
    f.where "MyString"
    f.moderator_id ""
  end
end