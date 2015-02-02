FactoryGirl.define do
  factory :curated_feed do |f|
    f.sequence(:title) {|n| "Global Cleveland #{n}" }
    f.description "Global Cleveland is focused on regional economic development through actively attracting newcomers, welcoming and connecting them both economically and socially to the many opportunities throughout Greater Cleveland."
  end
end