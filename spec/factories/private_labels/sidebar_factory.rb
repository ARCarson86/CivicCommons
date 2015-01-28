FactoryGirl.define do
  factory :sidebar, class: PrivateLabels::Sidebar do
    content { Faker::Lorem.paragraphs(1, true) }
  end
end
