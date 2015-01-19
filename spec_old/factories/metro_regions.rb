FactoryGirl.define do
  factory :metro_region do |f|
    f.sequence(:province) {|n| "Province #{n}"}
    f.sequence(:city_name) {|n| "City name #{n}"}
    f.sequence(:criteria_id) {|n| "00000#{n}"}
    f.sequence(:metro_name) {|n| "Metro name #{n}"}
    f.sequence(:display_name) {|n| "Display name #{n}"}
    f.sequence(:metrocode) {|n| "10#{n}"}
    f.sequence(:province_code) {|n| "Provice Code #{n}"}
  end
  factory :default_metro_region, :parent => :metro_region do |f|
    f.sequence(:metrocode) {|n| "510"}
  end
end