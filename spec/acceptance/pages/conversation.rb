module CivicCommonsDriver
module Pages
class Conversation
  class View
    SHORT_NAME = :view_conversation
    include Page
    def initialize options
      @conversation = options[:for]
    end
    def url
      "/conversations/#{@conversation.cached_slug}"
    end
  end
  class Start
    SHORT_NAME = :start_conversation
    include Page
    has_field :title, "Title"
    has_field :summary, "Summary"

    has_link :show_add_link_field, "contribution-add-link"
    has_link :show_add_file_field, "contribution-add-file"
    has_field :link_to_related, "conversation[contributions_attributes][0][url]"
    has_file_field :contribution_attachment, "conversation[contributions_attributes][0][attachment]"

    has_wysiwyg_editor_field :content, "conversation_contributions_attributes_0_content"
    has_button :start_my_conversation, "Start My Conversation", :invite_a_friend
    has_button :start_invalid_conversation, "Start My Conversation"

    def fill_in_conversation options = {}
      fill_in_title_with "Frank"
      fill_in_summary_with "stufffff!"
      fill_in_content_with "COOL! THIS IS AWESOME"
      select_issue "They are important"
      add_link options[:link_to_related_website] if options.key? :link_to_related_website
    end

    def add_link link
      follow_show_add_link_field_link
      fill_in_link_to_related_with link
    end

    def add_contribution_attachment
      follow_show_add_file_field_link
      attach_contribution_attachment_with_file File.join(attachments_path, 'imageAttachment.png')
    end

    def select_issue issue
      within "fieldset.issues" do
        check issue
      end
    end
    def submit_conversation(options = {})
      fill_in_conversation options
      click_start_my_conversation_button
    end
    def submit_invalid_conversation options={}
      fill_in_conversation options
      click_start_invalid_conversation_button
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
end
end
end
