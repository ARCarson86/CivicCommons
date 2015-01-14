FactoryGirl.define do
  factory :content_item_description do |f|
    f.content_type "RadioShow"
    f.description_short "Short description of the content item category."
    f.description_long "Long description of the content item category."
  end

  factory :blog_post_description, :parent => :content_item_description do |f|
    f.content_type "BlogPost"
  end

  factory :radio_show_description, :parent => :content_item_description do |f|
    f.content_type "RadioShow"
  end
end