module CivicCommonsDriver
  module Pages

    class RadioShow
      SHORT_NAME = :radio_show
      LOCATION = '/radioshow'

      include Page

      def follow_the_radio_show_link_for radio_show
        click_link radio_show.title
        set_current_page_to :radio_show_post
      end

      class Show
        SHORT_NAME = :radio_show_post
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
        SHORT_NAME = :view_radio_show
        include Page
        def initialize options
          @radio_show = options[:for]
        end
        def url
          "/radioshow/#{@radio_show.slug}"
        end
      end

    end

  end
end
