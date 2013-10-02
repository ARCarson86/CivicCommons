require 'acceptance/acceptance_helper'

feature " BlogPost Index", %q{
  As an visitor
  When I want to see blogposts
  I will be able view them
} do
  background do
    database.create_blog_post
  end

  def given_blog_posts_with_authors_and_topics
    @author1 = database.create_registered_user(:name => 'John Doe')
    @author2 = database.create_registered_user(:name => 'John Deer')
    @author3 = database.create_registered_user(:name => 'John Dobbs')
    database.destroy_all_content_items
    database.destroy_all_topics
    @blog1 = database.create_blog_post(:title => 'blog one', :author => @author1)
    @blog2 = database.create_blog_post(:title => 'blog two', :author => @author2)
    @blog3 = database.create_blog_post(:title => 'blog three', :author => @author3)
    @topic1 = @blog1.topics.first
    @topic2 = @blog2.topics.first
    @topic3 = @blog3.topics.first
  end

  scenario "Seeing the blog posts and filtering using authors", :js => true do
    given_blog_posts_with_authors_and_topics
    goto :blog

    page.should have_content "The Civic Commons Blog"
    page.should have_content @blog1.title
    page.should have_content @blog2.title
    page.should have_content @blog3.title
    page.should have_content @author1.name
    page.should have_content @author2.name
    page.should have_content @author3.name

    follow_filter_on_author @author1
    page.should have_content "Blog Posts by #{@author1.name}"
    page.should have_content @blog1.title
    page.should_not have_content @blog2.title
    page.should_not have_content @blog3.title

    follow_filter_on_author @author2
    page.should have_content "Blog Posts by #{@author2.name}"
    page.should have_content @blog2.title
    page.should_not have_content @blog1.title
    page.should_not have_content @blog3.title

    follow_remove_author_filter_link
    page.should have_content "The Civic Commons Blog"
    page.should have_content @blog1.title
    page.should have_content @blog2.title
    page.should have_content @blog3.title
  end

  scenario "Seeing the blog posts and filtering using Topics", :js => true do
    given_blog_posts_with_authors_and_topics
    goto :blog

    page.should have_content "The Civic Commons Blog"
    page.should have_content @topic1.name
    page.should have_content @topic2.name
    page.should have_content @topic3.name

    follow_filter_on_topic @topic1
    page.should have_content @blog1.title
    page.should_not have_content @blog2.title
    page.should_not have_content @blog3.title

    follow_filter_on_topic @topic2
    page.should_not have_content @blog1.title
    page.should have_content @blog2.title
    page.should_not have_content @blog3.title


    follow_filter_on_topic @topic3
    page.should_not have_content @blog1.title
    page.should_not have_content @blog2.title
    page.should have_content @blog3.title


    # follow_filter_on_author @author1
    # page.should have_content "Blog Posts by #{@author1.name}"
    # page.should have_content @blog1.title
    # page.should_not have_content @blog2.title
    # page.should_not have_content @blog3.title
    #
    # follow_filter_on_author @author2
    # page.should have_content "Blog Posts by #{@author2.name}"
    # page.should have_content @blog2.title
    # page.should_not have_content @blog1.title
    # page.should_not have_content @blog3.title
    #
    # follow_remove_author_filter_link
    # page.should have_content "The Civic Commons Blog"
    # page.should have_content @blog1.title
    # page.should have_content @blog2.title
    # page.should have_content @blog3.title
  end
end
