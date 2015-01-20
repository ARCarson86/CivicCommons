FactoryGirl.define do
  factory :issue do |f|
    f.sequence(:name) {|n| "Important Stuff #{n}" }
    f.created_at 3.months.ago
    f.updated_at 3.months.ago
    f.summary "All the important stuff happening in our region."
    f.index_summary "Custom summary for the issue shown on Issue index page."
    f.url_title nil
    f.total_visits 0
    f.recent_visits 0
    f.last_visit_date nil
    f.zip_code '44313' 
    f.position nil
    f.image File.new(Rails.root + 'spec/fixtures/images/test_image.jpg')
    f.topics { |topics| [topics.association(:topic)] }
  end

  factory :issue_with_conversation, :parent => :issue do |issue|
    issue.conversations { |conversation| [conversation.association(:conversation)] }
  end
end
