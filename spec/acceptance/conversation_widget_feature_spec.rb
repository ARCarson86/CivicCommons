require 'acceptance/acceptance_helper'

feature "Conversation Widget Feature", %q{
  As a visitor to a CC Partner Site
  I want to see contents from CC that's related to the site
  So that I can become engaged and interested in joining CC
} do

  def given_contribution_with_more_than250_chars
    @contribution = FactoryGirl.create(:contribution,{:conversation => @conversation,
      :content => 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus lorem. Fusce auctor. Nunc libero. Nam vel ante. Aenean semper arcu id augue tristique tempor. Nam congue. Vestibulum urna tellus, volutpat non, facilisis non, egestas at, nisl. Curabitur hendrerit.'})
  end

  def given_a_series_of_contributions
    @contribution1 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 1'})
    @contribution2 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 2'})
    @contribution3 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 3'})
    @contribution4 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 4'})
    @contribution5 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 5'})
    @contribution6 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 6'})
    @contribution7 = FactoryGirl.create(:contribution,{:conversation => @conversation, :content => 'Contribution Title here 7'})
  end

  before(:all) do
    ActiveRecord::Observer.enable_observers
  end

  after(:all) do
    ActiveRecord::Observer.disable_observers
  end

  background do
    @conversation = FactoryGirl.create(:conversation, :title => 'Akron Beacon Journal Seeks Citizen Views', :summary => 'Conversation Summary Here')
    @person = FactoryGirl.create(:normal_person)
  end
  scenario "Widget", :js => true do
    given_a_series_of_contributions
    visit '/example_cc_widget_for_rspec'
    sleep 2
    page.should have_content 'Akron Beacon Journal Seeks Citizen Views'
    page.should have_content 'Conversation Summary Here'
    page.should have_content('Contribution Title here')
    page.click_link('See More Activity')
    sleep 2
    page.should_not have_content('See More Activity')
  end

  scenario "Widget should have been limited to 250 characters", :js => true do
    given_contribution_with_more_than250_chars
    visit '/example_cc_widget_for_rspec'
    sleep 2
    page.should have_content("\"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Vivamus lorem. Fusce auctor. Nunc libero. Nam vel ante. Aenean semper arcu id augue tristique tempor. Nam congue. Vestibulum urna tellus, volutpat non, facilisis non, egestas at, nisl....\"")
    sleep 2
    page.should_not have_content('See More Activity')

  end

  scenario "Your commons embed page", :js => true do
    pending
    given_a_series_of_contributions
    visit conversation_path(@conversation)
    page.should have_content 'Akron Beacon Journal Seeks Citizen Views'
    page.click_link('Embed Conversation')

    page.should have_content 'Your Commons'
    page.should have_content 'Copy the code below.'
    page.should have_content 'Paste the code in your website'
    page.should have_content 'Invite friends to join your conversation.'
  end
end
