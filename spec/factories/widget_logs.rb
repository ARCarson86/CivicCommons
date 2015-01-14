FactoryGirl.define do
  factory :widget_log do |f|
    f.sequence(:url) {|n| "/url/here/#{n}" }
    f.sequence(:remote_url) {|n| "http://test.remote#{n}.com/url/here" }
  end
end