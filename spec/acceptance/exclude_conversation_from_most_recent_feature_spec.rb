require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')
WebMock.allow_net_connect!
Capybara.default_wait_time = 20

feature "Exclude conversation from 'most recent' filter", %q{
  As an admin
  I want to exclude a conversation from the Most Recent sort
  So that I can create conversations for partners without taking over the home page
} do

  scenario "Creating a conversation", :js => true do
    issue = FactoryGirl.create(:issue)

    # Given that I am an admin
    login_as :admin
    # When I go to the new conversation page through admin interface
    visit new_admin_conversation_path
    # And I check the "Exclude from Most Recent" checkbox
    check('Exclude from Most Recent')
    # And I fill in required conversation fields
    fill_in('Summary', with: 'short summary')
    fill_in('Title', with: 'Title of Conversation')
    fill_in('Zip Code', with: '12345')
    # And I click the "Submit" button
    click_button('Create Conversation')
    # When I visit the homepage
    visit('/')
    # Then I should not see the recently created conversation
    within('div.main-content') do
      page.should have_no_content('Title of Conversation')
    end
  end

  scenario "Editing a conversation", :js => true do
    conversation = FactoryGirl.create(:conversation)
    # Given that I am an admin
    login_as :admin
    # And a conversation is on the homepage
    visit('/')
    within('div.main-content') do
      page.should have_no_content('Title of Conversation')
    end
    # When I go to edit the conversation page through admin interface
    visit edit_admin_conversation_path(conversation)
    # And I check the "Exclude from Most Recent" checkbox
    check('Exclude from Most Recent')
    # And I click the "Submit" button
    click_button('Update Conversation')
    # When I visit the homepage
    visit('/')
    # Then I should not see the recently created conversation
    within('div.main-content') do
      page.should have_no_content(conversation.title)
    end
  end

  context "Viewing a conversation that is excluded from Most Recent" do
    scenario "View converstation on associated issue page" do
      # Given a conversation that is excluded from Most Recent
      conversation = FactoryGirl.create(:conversation, exclude_from_most_recent: true)
      # When I visit an issue page the conversation belongs to
      visit issue_path(conversation.issues.first)
      # Then I should see the conversation
      page.should have_content(conversation.title)
    end

    scenario "View converstation as part of 'Recommended'" do
      # Given a conversation that is excluded from Most Recent
      conversation = FactoryGirl.create(:conversation, exclude_from_most_recent: true, staff_pick: true)
      # When I visit an issue page the conversation belongs to
      visit conversations_filter_path('recommended')
      # Then I should see the conversation
      page.should have_content(conversation.title)
    end

    scenario "View converstation as part of region conversation listing" do
      region = FactoryGirl.create(:region)
      FactoryGirl.create(:zip_code, region: region, zip_code: '12345')
      # Given a conversation that is excluded from Most Recent
      conversation = FactoryGirl.create(:conversation, exclude_from_most_recent: true, zip_code: '12345')
      # When I visit an issue page the conversation belongs to
      visit region_path(region)
      # Then I should see the conversation
      page.should have_content(conversation.title)
    end
  end

end
