require 'acceptance/acceptance_helper'

feature "User Creates a User-Conversation", %q{
  As a normal user,
  I want to start a conversation and invite others to join
} do
  background do
    database.create_issue name: "They are important"
    database.create_project name: "Projects are important"
    database.create_metro_region
    database.create_metro_region
  end


  scenario "starting a conversation", :js => true do
    stub_metro_region_search
    login_as :person
    follow_start_conversation_link
    submit_conversation
    conversation.should exist_in_the_database
    the_current_page.should be_the_invite_a_friend_page_for_the conversation
  end

  scenario "inviting a friend when starting a conversation", :js => true do
    stub_metro_region_search
    login_as :person
    follow_start_conversation_link
    submit_conversation
    invite friend
    friend.should have_been_sent_an_invitation_to_join conversation
  end
  scenario "starting an invalid conversation", :js => true do
    stub_metro_region_search
    login_as :person
    follow_start_conversation_link
    submit_invalid_conversation :link_to_related_website => "this_isnt_a_good_link"

    current_page.should have_an_error_for :invalid_link
  end

  scenario "starting an invalid conversation with an attachment that needs a comment", :js => true do
    login_as :person
    follow_start_conversation_link
    add_contribution_attachment
    click_start_invalid_conversation_button
    current_page.should have_an_error_for :attachment_needs_comment
  end

  context "on Blog posts" do
    background do
      database.create_blog_post title: "Blog post title here"
      stub_metro_region_search
    end
    scenario "starting an invalid conversation with an attachment that needs a comment", :js => true do
      login_as :person
      follow_blog_link
      follow_the_blog_post_link_for database.latest_blog_post
      follow_start_conversation_link
      submit_conversation
      conversation.should exist_in_the_database
      conversation.content_items.should == [database.latest_blog_post]
      the_current_page.should be_the_invite_a_friend_page_for_the conversation
    end
  end

  context "on Radio Shows" do
    background do
      database.create_radio_show title: "Radio show title here"
      stub_metro_region_search
    end
    scenario "starting an invalid conversation with an attachment that needs a comment", :js => true do
      login_as :person
      follow_radio_show_link
      follow_the_radio_show_link_for database.latest_radio_show
      follow_start_conversation_link
      submit_conversation
      conversation.should exist_in_the_database
      conversation.content_items.should == [database.latest_radio_show]
      the_current_page.should be_the_invite_a_friend_page_for_the conversation
    end
  end
  
  def stub_metro_region_search
    #stub the search MetroRegion.search on the search controller
    metro_regions = MetroRegion.all
    MetroRegion.should_receive(:search_city_province).and_return(metro_regions)
    metro_regions.stub!(:results).and_return(metro_regions)
  end

  def friend
    Friend.new('bla@goolge.com')
  end
    class Friend
      attr_accessor :email
      def initialize(email)
        self.email = email
      end
      def has_been_sent_an_invitation_to_join?(conversation)
        mailing = ActionMailer::Base.deliveries.last
        expected_subject = "wants to invite you to a conversation"

        mailing.to.include? email and mailing.subject.include? expected_subject and mailing.body.include? "#{conversation.title}"
      end
    end
end
