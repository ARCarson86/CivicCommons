require_relative 'acceptance_helper'

feature "Organization Profiles", %q{
  In order to publicize my organization
  As an organization
  I would like a profile for it on the Civic Commons
} do

  background do
    @organization = database.has_an_organization
  end
  scenario "Joining an Organization", :js => true do
    login_as :person
    goto :organization_profile, for: organization
    follow_join_organization_link
    sleep 1
    follow_confirm_joining_organization_link
    leave_organization_link.should be_visible
    current_page.should have_avatar person
  end
  scenario "Leaving an Organization", :js => true do
    login_as :person
    goto :organization_profile, for: organization_with_member(person)
    current_page.should have_avatar person
    follow_leave_organization_link
    join_organization_link.should be_visible
    current_page.should have_content "I'm affiliated with this organization"
    current_page.should_not have_avatar person
  end

  scenario "Following an organization", :js => true do
    login_as :person
    goto :organization_profile, for: organization
    current_page.should_not have_subscriber_avatar person
    follow_subscribe_organization_link
    unsubscribe_organization_link.should be_visible
    current_page.should have_subscriber_avatar person
  end

  scenario "Un-following an organization", :js => true do
    pending
    login_as :person
    goto :organization_profile, for: organization_with_subscriber(person)
    current_page.should have_subscriber_avatar person
    follow_unsubscribe_organization_link
    subscribe_organization_link.should be_visible
    sleep 5
    current_page.should_not have_subscriber_avatar person
  end

  scenario "Viewing an Organization Profile" do
    pending
    goto :organization_profile, for: organization
    current_page.should have_contact_info_for organization
    current_page.should have_pluralized_itself
  end

  def organization
    @organization
  end

  def organization_with_member(person)
    @organization.join_as_member(person)
    return @organization
  end

  def organization_with_subscriber(person)
    Subscription.subscribe(@organization.type, @organization.id, person)
    @organization.reload
    return @organization
  end

  def person
    database.latest_person
  end

    #current_page.should have_content "Conversations we are following"
    #current_page.should have_content "Issues we are following"
    #current_page.should have_content "Our recent activity"
end
