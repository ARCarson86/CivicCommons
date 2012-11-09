module CivicCommonsDriver
  module Pages
    class Home
      SHORT_NAME = :home
      LOCATION = '/'
      include Page
      add_link(:start_conversation, "Start a Conversation", :start_conversation)
      has_link(:blog, 'Blog', :blog)
      has_link(:radio_show, 'Radio Show', :radio_show)
      has_link(:account_registration, 'register for an account', :registration_principles)

      def for? page
        has_css? ".feature-mast"
      end

    end
  end
end
