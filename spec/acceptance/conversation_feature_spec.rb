require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "View Conversation Page", %q{
  As a site visitor
  I want to view a static page
  So I can read the content
} do

  describe "visitng a conversation index page" do

    scenario "and the page exists" do
      # Given a converation
      # When I vist the conversation index page
      # Then I should be on the page
      # And I should see the conversation title
      # And the Topic Sidebar for that Conversation
      conversation = FactoryGirl.create(:conversation)
      visit conversations_path
      should_be_on conversations_path
      page.should have_content conversation.title
      page.should have_content conversation.topics.first.name
    end

  end

end
