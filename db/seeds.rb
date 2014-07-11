# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


# Create an Admin

admin = Person.create(email: "admin@admin.com", first_name: "Admin", last_name: "Admin", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now)
admin.admin = true
admin.save!

# Create people
user_1 = Person.create!(email: "nconan@test.com", first_name: "Neal", last_name: "Conan", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now)
user_2 = Person.create!(email: "chayes@test.com", first_name: "Chauncy", last_name: "Hart", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now)
user_3 = Person.create!(email: "rrowe@test.com", first_name: "Rob", last_name: "Rowe", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now)
user_4 = Person.create!(email: "jduke@test.com", first_name: "Jenny", last_name: "Duke", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, subscription_settings: "daily")
user_5 = Person.create!(email: "bbaggins@test.com", first_name: "Barry", last_name: "Baggins", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, subscription_settings: "daily")
user_6 = Person.create!(email: "kruss@test.com", first_name: "Kurt", last_name: "Russ", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, subscription_settings: "weekly")
user_7 = Person.create!(email: "jross@test.com", first_name: "Jay", last_name: "Ross", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, subscription_settings: "never")
user_8 = Person.create!(email: "msmith@test.com", first_name: "Mike", last_name: "Smith", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, subscription_settings: "realtime")
user_9 = Person.create!(email: "acampman@test.com", first_name: "Adam", last_name: "Campman", password: "password", zip_code: "44221", proxy: true, confirmed_at: Time.now, tag_notification: false, subscription_settings: "weekly")
user_10 = Person.create!(email: "Kreed@test.com", first_name: "Kenton", last_name: "Reed", password: "password", zip_code: "44221", proxy: true)

#Create Articles
Article.create(title: "An Introduction to the Civic Commons", author: "Dan Moulthrop", current: true, description: "Here's a short introduction to what this project is all about. Please check it out! It was made possible by lots of people, including a group of superfriends who sent in pictures.")
Article.create(title: "How to help build the Commons", author: "Dan Moulthrop", current: false, description: "Here's a short video explaining the many ways you're already helping to build the Commons and other ways you might try. Thanks for checking it out!")
Article.create(title: "Our Principles", author: "Lia Lockert", current: false, description: "These are our principles, the basic foundations guiding the work we do and how we do it. They're shared here by those who joined us for the National Day of Conversation, citizen journalists at the Akron Digital Media Center, and other friends throughout the community.")
Article.create(title: "How to use theciviccommons.com", author: "Dan Moulthrop", current: false, description: "Here's a brief tour of theciviccommons.com and a little about how to join the conversation online and how this isn't your typical social networky/civic-minded website. It's better. And it's beta.")
Article.create(title: "Grappling with responding to your feedback", author: "Dan Moulthrop", current: false, description: "We realize it’s maybe not entirely clear what you can do here and why you would want to do it. One of the most common bits of feedback we received last week goes something like")
Article.create(title: "No One has ever asked me before", author: "Dan Moulthrop", current: false, description: "Join the ongoing conversation about what your Civic Commons can be. It's a conversation about conversations. Yeah, that's right. It's meta")
Article.create(title: "The Civic Commons Poster Contest", author: "CC Staff", current: false, description: "The Commons is giving away five $500 prizes in a poster contest. You can participate by using any 11 x 17 surface to creatively express what it means to Join the Conversation. Click through for details.")

# Create Metro Region
metro_region_1 = MetroRegion.create!(province: "Ohio", city_name: "Hudson", metro_name: "Cleveland OH", province_code: "US-OH", metrocode: 1, city_province_token:"hudson-ohio", display_name: "Cleveland OH" )
metro_region_2 = MetroRegion.create!(province: "Ohio", city_name: "Independence", metro_name: "Cleveland OH", province_code: "US-OH", metrocode: 1, city_province_token:"independence-ohio", display_name: "Cleveland OH" )
metro_region_3 = MetroRegion.create!(province: "Ohio", city_name: "Brooklyn", metro_name: "Cleveland OH", province_code: "US-OH", metrocode: 1, city_province_token:"brooklyn-ohio", display_name: "Cleveland OH" )
metro_region_4 = MetroRegion.create!(province: "Ohio", city_name: "Cuyahoga Falls", metro_name: "Cleveland OH", province_code: "US-OH", metrocode: 1, city_province_token:"cuyahoga-falls-ohio", display_name: "Cleveland OH" )
metro_region_5 = MetroRegion.create!(province: "Ohio", city_name: "Dublin", metro_name: "Columbus OH", province_code: "US-OH", metrocode: 2, city_province_token:"dublin-ohio", display_name: "Columbus OH" )
metro_region_6 = MetroRegion.create!(province: "Ohio", city_name: "Columbus", metro_name: "Columbus OH", province_code: "US-OH", metrocode: 2, city_province_token:"columbus-ohio", display_name: "Columbus OH" )
metro_region_7 = MetroRegion.create!(province: "Ohio", city_name: "Pickerington", metro_name: "Columbus OH", province_code: "US-OH", metrocode: 2, city_province_token:"pickerington-ohio", display_name: "Columbus OH" )
metro_region_8 = MetroRegion.create!(province: "Ohio", city_name: "Hillard", metro_name: "Columbus OH", province_code: "US-OH", metrocode: 2, city_province_token:"hillard-ohio", display_name: "Columbus OH" )
metro_region_9 = MetroRegion.create!(province: "Ohio", city_name: "Westlake", metro_name: "Cleveland OH", province_code: "US-OH", metrocode: 1, city_province_token:"westlake-ohio", display_name: "Cleveland OH" )

# Create Topics
topic_1 = Topic.create!(name: "Arts")
topic_2 = Topic.create!(name: "Health")
topic_3 = Topic.create!(name: "Politics")
topic_4 = Topic.create!(name: "Crime")
topic_5 = Topic.create!(name: "Education")

# Create Issues
issue = Issue.new(name: "Opportunity Corridor", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.", topic_ids: [topic_1.id])
issue.type = "ManagedIssue"
issue.image = File.open('app/assets/images/cc_radio_show.jpg')
issue.save!

issue_2 = Issue.new(name: "A Big Issue", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.", topic_ids: [topic_4.id])
issue_2.type = "ManagedIssue"
issue_2.image = File.open('app/assets/images/cc_radio_show.jpg')
issue_2.save!

issue_3 = Issue.new(name: "Another Issue", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.", topic_ids: [topic_2.id])
issue_3.type = "ManagedIssue"
issue_3.image = File.open('app/assets/images/cc_radio_show.jpg')
issue_3.save!

issue_4 = Issue.new(name: "Fourth Issue", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.", topic_ids: [topic_3.id])
issue_4.type = "ManagedIssue"
issue_4.image = File.open('app/assets/images/cc_radio_show.jpg')
issue_4.save!

# Create Subscription
subscription_1 = Subscription.create!(subscribable_type: "Conversation", person_id: admin.id)
subscription_2 = Subscription.create!(subscribable_type: "Conversation", person_id: admin.id)
subscription_3 = Subscription.create!(subscribable_type: "Conversation", person_id: admin.id)
subscription_4 = Subscription.create!(subscribable_type: "Conversation", person_id: admin.id)

# Create Conversations
conversation_1 = Conversation.new(title: "Frontline", zip_code: "44301", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.")
conversation_1.topics = [topic_1, topic_2]
conversation_1.metro_region_id = metro_region_1.id
conversation_1.owner = user_1.id
conversation_1.people = [admin]
conversation_1.subscriptions = [subscription_1]
conversation_1.save!(validate: false)

conversation_2 = Conversation.new(title: "Ohio Tax", zip_code: "44301", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.")
conversation_2.topics = [topic_2]
conversation_2.metro_region_id = metro_region_1.id
conversation_2.owner = user_1.id
conversation_2.people = [admin]
conversation_2.subscriptions = [subscription_2]
conversation_2.save!(validate: false)

conversation_3 = Conversation.new(title: "Another One", zip_code: "44301", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.")
conversation_3.topics = [topic_1]
conversation_3.metro_region_id = metro_region_2.id
conversation_3.owner = user_2.id
conversation_3.people = [admin]
conversation_3.subscriptions = [subscription_3]
conversation_3.save!(validate: false)

conversation_4 = Conversation.new(title: "Thoughts?", zip_code: "44301", summary: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin at velit lacus, vel lobortis quam. Duis eget odio lacus. Quisque ac.")
conversation_4.topics = [topic_2]
conversation_4.metro_region_id = metro_region_6.id
conversation_4.owner = user_2.id
conversation_4.people = [admin]
conversation_4.subscriptions = [subscription_4]
conversation_4.save!(validate: false)

# Create Contributions
contribution_1 = Contribution.new(content: "Ipsum Lorem")
contribution_1.owner = user_1.id
contribution_1.conversation_id = conversation_1.id
contribution_1.top_level_contribution = true
contribution_1.item = conversation_1
contribution_1.confirmed = true
contribution_1.save!

contribution_2 = Contribution.new(content: "Ipsum Lorem")
contribution_2.owner = user_2.id
contribution_2.conversation_id = conversation_1.id
contribution_2.parent_id = contribution_1.id
contribution_2.item = conversation_1
contribution_1.confirmed = true
contribution_2.save!

# Create Petition
petition_1 = Petition.create!(title: "Say No", description: "Ipsum Lorem", resulting_actions: "Ipsum Lorem", signature_needed: 20, person_id: user_1.id, conversation_id: conversation_1.id)

# Create Petition Signature
petition_signature = PetitionSignature.create!(petition_id: petition_1.id, person_id: user_1.id)

# Create Rating Descriptors
informative = RatingDescriptor.create!(title: "Informative")
persuasive = RatingDescriptor.create!(title: "Persuasive")
inspiring = RatingDescriptor.create!(title: "Inspiring")

# Create Rating Groups
rating_group_1 = RatingGroup.create!(person_id: user_1.id, contribution_id: contribution_2.id)
rating_group_2 = RatingGroup.create!(person_id: user_2.id, contribution_id: contribution_1.id)
rating_group_3 = RatingGroup.create!(person_id: user_3.id, contribution_id: contribution_2.id)

# Create Ratings
rating_1 = Rating.create!(rating_group_id: rating_group_1.id, rating_descriptor_id: informative.id)
rating_2 = Rating.create!(rating_group_id: rating_group_2.id, rating_descriptor_id: informative.id)
rating_3 = Rating.create!(rating_group_id: rating_group_3.id, rating_descriptor_id: persuasive.id)

# Create Survey
survey_1 = Survey.new(title: "Are You Here?", surveyable_type: "Conversation", description: "Ipsum", max_selected_options: 1, person_id: user_1.id)
survey_1.type = "Vote"
survey_1.surveyable_id = conversation_1.id
survey_1.end_date = "2001-02-03"
survey_1.save!

# Create Survey Response
survey_response_1 = SurveyResponse.create!(survey_id: survey_1.id, person_id: user_1.id)