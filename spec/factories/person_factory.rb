FactoryGirl.define do
  factory :person do
    first_name              { Faker::Name.first_name }
    last_name               { Faker::Name.last_name }
    title                   { Faker::Name.title }
    zip_code                { Faker::Address.zip_code }
    password                { Faker::Internet.password }
    email                   { Faker::Internet.safe_email }
    daily_digest            false
    avatar_url              '/images/avatar_70.gif'
    avatar_cached_image_url '/images/avatar.jpg'
    send_welcome            false

    factory :confirmed_person do
      confirmed_at           { Faker::Time.backward(1.month) } 

      factory :admin do
        admin                 true
      end
    end
  end
end
