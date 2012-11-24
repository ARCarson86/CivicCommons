module CivicCommonsDriver
  module Pages

    class Admin
      SHORT_NAME = :admin
      LOCATION = '/admin'
      include Page
      add_link(:conversations, "Conversations", :admin_conversations)

      add_link(:issues, "Managed Issues", :admin_issues)
      add_link(:add_issue, "Add Managed Issue", :admin_add_issue)

      add_link(:topics, "Topics", :admin_topics)
      add_link(:add_topic, "Add Topic", :admin_add_topic)

      add_link(:radio_shows, "Radio Shows", :admin_radio_shows)

      add_link(:blog_posts, "Blog Posts", :admin_blog_posts)
      has_link(:add_content_item, 'Add Content Item', :admin_add_content_item)
    end

  end
end
