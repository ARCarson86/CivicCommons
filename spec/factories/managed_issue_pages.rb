FactoryGirl.define do
  factory :managed_issue_page do |f|
    f.sequence(:name) {|n| "Big, Important Issue #{n}" }
    f.template "Big honkin' blob of CCML..."
    f.stylesheet_path "http://s3.amazon.com/my_styles.css"
    f.created_at 1.week.ago
    f.association :issue, :factory => :managed_issue
    f.association :author, :factory => :admin_person
  end
end