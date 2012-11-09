module CivicCommonsDriver
  module Pages
    class Blog
      SHORT_NAME = :blog
      LOCATION = '/blog'
      include Page
      
      has_link :remove_author_filter, 'Remove Filter', :blog

      def follow_the_blog_post_link_for blog_post
        click_link blog_post.title
        set_current_page_to :blog_post
      end
      
      def follow_filter_on_author(author)
        within '.site-filter' do
          follow_link author.name, :blog
        end
      end

      def follow_filter_on_topic(topic)
        within '.topic-filter' do
          follow_link topic.name, :blog
        end
      end
      

      class Show
        SHORT_NAME = :blog_post
        include Page

        has_link(:start_conversation, "Start a Conversation", :start_conversation)
        has_link :show_add_file_field, "contribution-add-file"
        has_file_field :contribution_attachment, "conversation[contributions_attributes][0][attachment]"
        has_button :start_invalid_conversation, "Start My Conversation"

        def add_contribution_attachment
          follow_show_add_file_field_link
          attach_contribution_attachment_with_file File.join(attachments_path, 'imageAttachment.png')
        end

        def has_an_error_for? field
          case field
          when :invalid_link
            error_msg = "The link you provided is invalid"
          when :attachment_needs_comment
            error_msg = 'Sorry! You must also write a comment above when you upload a file.'
          end
          has_content? error_msg
        end
      end

      class View
        SHORT_NAME = :view_blog_post
        include Page
        def initialize options
          @blog_post = options[:for]
        end
        def url
          "/blog/#{@blog_post.slug}"
        end
      end

    end

  end
end
