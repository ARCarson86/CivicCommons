# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :region do |f|
    f.name "MyString"
    f.image File.new(Rails.root + 'spec/fixtures/images/test_image.jpg')
  end
end
