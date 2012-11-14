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
      "/conversations/#{@conversation.slug}"
    end
  end

  class Index
    SHORT_NAME = :conversations
    include Page
    def url
      "/conversations"
    end
  end

  class Start
    SHORT_NAME = :start_conversation
    include Page
    has_field :title, "Title"
    has_field :summary, "Summary"

    has_field :link, "conversation_link"
    has_field :metro_region_city_display_name, "conversation_metro_region_city_display_name"
    has_file_field :contribution_attachment, "conversation[contributions_attributes][0][attachment]"

    has_checkbox :civility_checkbox, "conversation_agree_to_be_civil"

    has_checkbox :accept_civility_modal, 'agree-on-agree-to-be-civil-modal'
    has_link :continue_on_accept_civility_modal, 'Continue', :invite_a_friend

    has_button :start_my_conversation, "Start My Conversation", :invite_a_friend
    has_button :start_invalid_conversation, "Start My Conversation"

    def fill_in_conversation options = {}
      fill_in_title_with "Frank"
      fill_in_summary_with "stufffff!"
      fill_in_link_with "http://theciviccommons.com"
      fill_in_metro_region_city_display_name_with "City name"
      sleep 1
      find('.ui-menu-item a:first').click
      check_civility_checkbox if !(options.has_key?(:check_civility_checkbox) && options[:check_civility_checkbox] == false)
    end

    def accept_the_agree_to_be_civil_modal
      sleep 1
      check_accept_civility_modal
      follow_continue_on_accept_civility_modal_link
      sleep 1
    end

    def add_contribution_attachment
      follow_show_add_file_field_link
      attach_contribution_attachment_with_file File.join(attachments_path, 'imageAttachment.png')
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
