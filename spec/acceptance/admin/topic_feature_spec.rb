#failure goto_admin_page_as_admin
require 'acceptance/acceptance_helper'

feature "Topic Admin", %q{
  In order to Administer Topics
  As a an Admin user
  I want to access the topic admin feature
} do

  scenario "creating a topic" do
    goto_admin_page_as_admin
    follow_add_topic_link
    submit_topic "WOOHOO!"

    submitted_topic.should exist_in_the_database
    current_page.should be_for submitted_topic
  end

  scenario "deleting a topic", :js => true do
    database.create_topic name: "bla"

    goto_admin_page_as_admin
    follow_topics_link
    delete_topic topic

    topic.should be_removed_from page
    database.should_not have_any_topics
  end

  scenario "updating a topic" do
    database.create_topic name: "bla"

    goto_admin_page_as_admin
    follow_topics_link

    follow_edit_link_for topic

    submit_topic 'bork bork bork'
    database.latest_topic.name.should == "bork bork bork"
    current_page.should be_for database.latest_topic
  end

  scenario "submitting an empty topic" do
    goto_admin_page_as_admin

    follow_add_topic_link

    submit_blank_topic
    current_page.should have_an_error
    database.should_not have_any :topics
  end

  before do
    @topic = nil
  end
  def topic
    @topic ||= database.latest_topic
  end
end

