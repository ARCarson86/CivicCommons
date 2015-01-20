FactoryGirl.define do |f|

  factory :normal_person, :class=>Person do |u|
    u.first_name { Faker::Name.first_name }
    u.last_name { Faker::Name.last_name }
    u.title { Faker::Name.title }
    u.zip_code '44313'
    u.password 'password'
    u.email { Faker::Internet.email }
    u.daily_digest false
    u.avatar_url '/images/avatar_70.gif'
    u.avatar_cached_image_url '/images/avatar.jpg'
    u.send_welcome false
  end

  factory :proxy_person, :parent => :normal_person do |u|
    u.proxy true
  end

  factory :registered_user, :parent => :normal_person do |u|
    u.confirmed_at { Time.now }
    u.declined_fb_auth true
  end

  factory :person, :parent => :registered_user do | u |
    u
  end

  factory :admin_person, :parent => :registered_user do |u|
    u.admin true
  end

  factory :admin, :parent => :admin_person
  
end
