module CivicCommonsDriver
module Pages
  class InviteAFriend
    SHORT_NAME = :invite_a_friend
    include Page
    add_field(:emails, 'invite_emails')
    add_button(:send, 'Send', :view_conversation)

    def invite friend
      fill_in_emails_with friend.email
      click_send_button
    end

    def the_invite_a_friend_page_for_the? conversation
      has_content?("Invite a Friend")
    end

  end
end
end
