# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content_item_link do
      title "Content Item Link Title here"
      description "Content Item Link Description Here"
      url "http://urlhere.test"
      content_item_id 1
    end
end