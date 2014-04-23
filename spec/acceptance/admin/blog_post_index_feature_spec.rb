#goto_admin fail
require 'acceptance/acceptance_helper'

feature "Admin BlogPost Index", %q{
  As an admin
  When I want the description of all blog posts to be changed
  I will be able to edit - change or delete this text in my admin pages
} do
  background do
    goto_admin_page_as_admin
    follow_blog_posts_link
  end

  scenario "Add new long description for BlogPosts" do
    database.should_not have_any_blog_post_descriptions
    fill_in_blog_post_descriptions_with defaults
    click_update_blogpost_descriptions_button
    database.should have_any_blog_post_descriptions
  end

  scenario "Edit long description for RadioShows" do
    fill_in_blog_post_descriptions_with :description_long => 'longer'
    click_update_blogpost_descriptions_button
    blog_post_description = database.latest_blog_post_description
    blog_post_description.description_long.should == 'longer'
  end
end