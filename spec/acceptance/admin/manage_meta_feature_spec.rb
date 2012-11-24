require 'acceptance/acceptance_helper'

feature "Meta Content", %q{
  In order to help people find stuff easier from google
  As an admin
  I want to be able to add meta fields to our site
} do

  background do
    database.has_a_radio_show
    database.has_a_blog_post
    goto_admin_page_as_admin
  end

  scenario "Configure Conversation Metadata", :js=>true do
    database.has_a_conversation
    update_conversation :page_title=>"Woah! this rocks!",
                        :meta_description=>"THAT IS SO META",
                        :meta_tags=>"face,is,awesome"
    goto :view_conversation, :for=> conversation
    current_page.should have_page_title "Woah! this rocks!"
    current_page.should have_meta_description "THAT IS SO META"
    current_page.should have_meta_tags "face,is,awesome"
  end

  scenario "Configure Project Metadata", :js=>true do
    database.has_a_project
    update_project :page_title=>"Issues, I have them",
                   :meta_description=>"But I canna talk about it",
                   :meta_tags=>"because,it,would,scare,you"
    goto :issue_detail, :for=> project
    current_page.should have_page_title "Issues, I have them"
    current_page.should have_meta_description "But I canna talk about it"
    current_page.should have_meta_tags "because,it,would,scare,you"
  end

  scenario "Configure Radio Metadata", :js=>true do
    update_radio_show :page_title=>"Welcome to RADIOLAB",
                         :meta_description=>"OK, so it is not really radiolab",
                         :meta_tags=>"we,just,wish,we,were,radiolab"
    goto :view_radio_show, :for=> radio_show
    current_page.should have_page_title "The Civic Commons Radio Show: Welcome to RADIOLAB"
    current_page.should have_meta_description "OK, so it is not really radiolab"
    current_page.should have_meta_tags "we,just,wish,we,were,radiolab"
  end

  scenario "Configure Blog Metadata", :js=>true do
    update_blog_post :page_title=>"Blogging is fun!",
                     :meta_description=>"Just ask Arianna Huffington",
                     :meta_tags=>"if,you,can,get,past,her,millions,of,dollars"
    goto :view_blog_post, :for=> blog_post
    current_page.should have_page_title "The Civic Commons Blog: Blogging is fun!"
    current_page.should have_meta_description "Just ask Arianna Huffington"
    current_page.should have_meta_tags "if,you,can,get,past,her,millions,of,dollars"
  end

  def fill_in_meta_data_fields options
    fill_in_page_title_with options[:page_title]
    fill_in_meta_description_with options[:meta_description]
    fill_in_meta_tags_with options[:meta_tags]
  end

  ##### Conversation Setup #####

  def update_conversation options
    follow_conversations_link
    follow_edit_link_for conversation
    fill_in_meta_data_fields options
    click_update_conversation_button
  end

  def conversation
    conversation = Database.conversation
    conversation.instance_eval do
      def container
        "tr[data-conversation-id='#{id}']"
      end
    end
    conversation
  end

  ##### Project Setup #####

  def update_project options
    follow_issues_link
    follow_edit_link_for project
    fill_in_meta_data_fields options
    click_update_issue_button
  end

  def project
    project = Database.latest_issue
    project.instance_eval do
      def container
        "tr[data-issue-id='#{id}']"
      end
    end
    project
  end

  ##### Radio Show Setup #####

  def update_radio_show options
    follow_radio_shows_link
    follow_edit_link_for radio_show
    fill_in_meta_data_fields options
    click_update_content_item_button
  end

  def radio_show
    radio_show = Database.radio_show
    radio_show.instance_eval do
      def container
        "tr[data-radio-show-id='#{id}']"
      end
    end
    radio_show
  end

  ##### Blog Post Setup #####

  def update_blog_post options
    follow_blog_posts_link
    follow_edit_link_for blog_post
    fill_in_meta_data_fields options
    click_update_content_item_button
  end

  def blog_post
    blog_post = Database.blog_post
    blog_post.instance_eval do
      def container
        "tr[data-blog-post-id='#{id}']"
      end
    end
    blog_post
  end

end
