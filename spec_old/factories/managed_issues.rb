FactoryGirl.define do
  factory :managed_issue do |f|
    f.sequence(:name) {|n| "Really Important Stuff #{n}" }
    f.created_at 3.months.ago
    f.updated_at 3.months.ago
    f.summary "The most important stuff happening in our region."
    f.url_title nil
    f.total_visits 0
    f.recent_visits 0
    f.last_visit_date nil
    f.zip_code '44313'
    #f.association :index, :factory => :managed_issue_page
    f.image File.new(Rails.root + 'spec/fixtures/images/test_image.jpg')
    f.topics { |topics| [topics.association(:topic)] }
  end
  
  factory :managed_issue_with_conversation, :parent => :managed_issue do |issue|
    issue.conversations { |conversation| [conversation.association(:conversation)] }
  end
  
end
