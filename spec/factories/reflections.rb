# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  FactoryGirl.define do
    factory :reflection do
      sequence(:title) {|n| "Reflection Title #{n}" }
      details "MyText"
      association :person, factory: :registered_user
      association :conversation, factory: :conversation
    end

    factory :reflection_with_comments, :parent => :reflection do
      comments { |reflection| [reflection.association(:reflection_comment)] }
    end
  end
end