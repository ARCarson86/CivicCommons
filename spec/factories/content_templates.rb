FactoryGirl.define do
  factory :content_template do |f|
    f.association :author, :factory => :admin_person
    f.sequence(:name) {|n| "Sample Template #{n}" }
    f.template "Lorem ipsum..."
    f.created_at 1.week.ago
  end
end