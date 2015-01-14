FactoryGirl.define do
  factory :featured_opportunity do |f|
    f.association :conversation
    f.contributions {|r| [r.association(:contribution)]}
    f.actions {|r| [r.association(:action)]}
    f.reflections {|r| [r.association(:reflection)]}
  end
end