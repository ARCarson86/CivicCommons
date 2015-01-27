FactoryGirl.define do
  factory :sidebar, class: PrivateLabels::Sidebar do
    content { Faker::Lipsum.paragraphs(3) }
  end
end
