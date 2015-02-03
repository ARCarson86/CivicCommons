FactoryGirl.define do
  factory :page, class: PrivateLabels::Page do
    title { Faker::Lorem.words(Random.rand(2..4)) }
    content { Faker::Lorem.paragraphs(1, true) }
  end
end
