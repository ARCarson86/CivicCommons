# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do |f|
    f.title "MyString"
    f.author "MyString"
    f.description "MyText"
    f.link "MyString"
    f.video_url ""
    f.percent "MyString"
    f.current false
  end

  factory :youtube_article, :parent => :article do |f|
    f.video_url "http://www.youtube.com/watch?v=djtNtt8jDW4"
  end
end