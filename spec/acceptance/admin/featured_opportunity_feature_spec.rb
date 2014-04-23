#failed login_as :admin_person
require 'acceptance/acceptance_helper'

feature " Featured Opportunity", %q{
  As an admin user
  When I want to display featured opportunites
  I should be able to manage it on admin interface
} do

  def given_a_conversation_with_associated_items
    @conversation = FactoryGirl.create(:conversation, :title => 'Convo Opps title here')

    #contributions
    @contribution1 = FactoryGirl.create(:contribution,:conversation => @conversation, :content => 'Contribution 1 content')
    @contribution2 = FactoryGirl.create(:contribution,:conversation => @conversation, :content => 'Contribution 2 content')

    #actions
    @petition = FactoryGirl.create(:petition, :conversation => @conversation, :title => 'Petition title')
    @vote = FactoryGirl.create(:vote, :surveyable => @conversation, :title => 'Vote title')
    @action1 = @petition.action
    @action2 = @vote.action

    #reflections
    @reflection1 = FactoryGirl.create(:reflection, :conversation => @conversation, :title => 'Reflection title 1')
    @reflection2 = FactoryGirl.create(:reflection, :conversation => @conversation, :title => 'Reflection title 2')

  end

  def given_a_featured_opportunity
    @featured_opportunity = FactoryGirl.create(:featured_opportunity, :conversation => @conversation,
                                               :contributions => [@contribution2],
                                               :actions => [@action2],
                                               :reflections => [@reflection2])
  end

  scenario "Creating a featured opportunity", :js => true do
    given_a_conversation_with_associated_items
    login_as :admin_person
    visit admin_featured_opportunities_path
    set_current_page_to :admin_featured_opportunities
    follow_add_featured_opportunity_link

    fill_in_conversation_with @conversation.title

    sleep 1
    fill_in_contribution_with @contribution2.one_line_summary
    fill_in_action_with @action2.one_line_summary
    fill_in_reflection_with @reflection2.one_line_summary

    click_create_button
  end

  scenario "Editing a featured opportunity", :js => true do
    given_a_conversation_with_associated_items
    given_a_featured_opportunity
    login_as :admin_person
    visit admin_featured_opportunities_path
    set_current_page_to :admin_featured_opportunities

    follow_edit_link_for database.latest_featured_opportunity

    fill_in_contribution_with @contribution1.one_line_summary
    fill_in_action_with @action1.one_line_summary
    fill_in_reflection_with @reflection1.one_line_summary

    click_update_button
  end

  scenario "Deleting a featured opportunity", :js => true do
    given_a_conversation_with_associated_items
    given_a_featured_opportunity
    login_as :admin_person

    visit admin_featured_opportunities_path
    set_current_page_to :admin_featured_opportunities

    page.should have_content @conversation.title

    follow_delete_link_for database.latest_featured_opportunity
    accept_alert
    page.should_not have_content @conversation.title
  end
end