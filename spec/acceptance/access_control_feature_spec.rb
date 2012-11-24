require 'acceptance/acceptance_helper'

feature "Access Control Feature", %q{
  In order to do something
  As an user
  I should be able to get to parts of the site that is authorized for me

} do
  background do
    database.has_a_topic
  end
  
  def home_link
    ['The Civic Commons Home']
  end
  
  def blog_admin_dashboard_links
    [
      'Blog Posts',
      'Add Content Item'
    ] + home_link
  end
  
  def blog_admin_restricted_controller_links
    [
      admin_articles_path,
      admin_content_templates_path ,
      admin_widget_stats_path ,
      admin_conversations_path ,
      admin_curated_feeds_path ,
      admin_issues_path,
      admin_regions_path ,
      admin_email_restrictions_path ,
      admin_surveys_path ,
      admin_topics_path ,
      admin_people_path,
      admin_featured_opportunities_path ,
      admin_metro_regions_path
    ]
  end
  
  def admin_dashboard_links
    [
      'Featured Homepage Items',
      'Featured Opportunities',
      'Articles',
      'Add Article',
      'Conversations',
      'Add Conversation',
      'Metro Regions',
      'Display Names',
      'Topics',
      'Add Topic',
      'Managed Issues',
      'Add Managed Issue',
      'Managed Issue Pages',
      'People',
      'Register User',
      'Proxy Accounts',
      'Add Proxy Account',
      'Export Members to CSV',
      'Blog Posts',
      'News Items',
      'Radio Shows',
      'Add Content Item',
      'Static Pages',
      'Add Static Page',
      'Curated Feeds',
      'Add Feed',
      'Surveys',
      'Add Survey',
      'Email Restrictions',
      'Add Email Restrictions',
      'Your Commons Stats'
    ] + home_link
  end
  
  def should_have_links(links)
    links.each do |link|
      current_page.should have_link link
    end
  end

  def should_not_have_links(links)
    links.each do |link|
      current_page.should_not have_link link
    end
  end
  
  def should_not_restrict_access_on_links(links)
    links.each do |link|
      visit admin_root_path
      current_page.click_link link
      current_page.current_path.inspect.should_not == root_path
    end
  end  
  
  def should_restrict_controller_access(links)
    links.each do |link|
      visit link
      current_page.current_path.should == root_path
    end
  end
  
  scenario "As an admin, I can go to all controllers within the admin interface" do
    login_as :admin_person
    visit admin_root_path
    current_page.should have_content 'Dashboard'
    should_have_links(admin_dashboard_links)
    should_not_restrict_access_on_links(admin_dashboard_links - home_link)
  end
  
  scenario "As a blog admin, I can go to dashboard and content_item's controller only" do
    login_as :blog_admin_person
    visit admin_root_path
    should_have_links(blog_admin_dashboard_links)
    should_not_have_links(admin_dashboard_links - blog_admin_dashboard_links)
    should_not_restrict_access_on_links(blog_admin_dashboard_links - home_link)
    should_restrict_controller_access(blog_admin_restricted_controller_links)
  end  

end
