require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Issue Feature", %q{
  As an visitor person
  I want to see issues and community on issues
  So that I can understand issues on civiccommons
} do

  background do
    database.create_issue name: "Issue Title Here"
    person1 = database.create_registered_user
    person2 = database.create_registered_user
    conversation1 = database.create_conversation :owner => person1.id
    conversation2 = database.create_conversation :owner => person2.id
    issue.conversations = [conversation1, conversation2]
    database.create_contribution(:person => person1, :conversation => conversation1)
    database.create_contribution(:person => person2, :conversation => conversation2)
  end

  def issue
    database.latest_issue
  end

  scenario "User signs up without facebook", :js => true do
    login_as :person
    goto :issue_detail, :for => issue

    follow_people_active_in_this_issue_link

    follow_people_and_organizations_link
    follow_people_only_link
    follow_organizations_only_link

    follow_newest_members_link
    follow_most_active_link
    follow_alphabetical_link
  end

end
