# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :conversation do |f|
    f.started_at ""
    f.finished_at ""
    f.summary "MyString"
    f.sequence(:title) {|n| "Some Random Title #{n}" }
    f.zip_code "48105"
    f.issues { |c| [c.association(:issue)] }
    f.from_community false
    f.association :person, :factory => :admin_person
    # f.metro_region_id '123'
    f.association :metro_region, :factory => :default_metro_region
    f.starter "This text what we use to help start a conversation."

    before(:create) do |conversation|
      conversation.topics << FactoryGirl.create(:topic)
    end
  end

  factory :user_generated_conversation, :parent => :conversation do |f|
    f.contributions { |c| [c.association(:contribution)] }
    f.from_community true
    f.association :person, :factory => :registered_user
    f.starter "This text what we use to help start a conversation."
  end
end
