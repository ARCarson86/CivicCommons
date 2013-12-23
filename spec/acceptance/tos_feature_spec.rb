require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Report Terms of Service Violation", %q{
  As a registered user,
  I want to report content that violates the Terms of Service
  So that action can be taken by site management
} do


  scenario "Display the Report Abuse text" do
    pending
    given_i_am_on_a_conversation_page_with_a_contribution
    then_the_page_has_a_report_abuse_link
  end

  scenario "report a contribution" do
    given_i_am_on_a_conversation_page_with_a_contribution
    when_i_report_the_contribution
    then_the_contribution_is_flagged_for_moderation
  end

end
