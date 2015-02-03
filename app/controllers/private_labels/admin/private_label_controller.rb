module PrivateLabels
  module Admin

    class PrivateLabelController < BaseController
      before_filter :load_private_label
      authorize_resource

      ##
      # Display the settings for the current private label
      def show
      end

      ##
      # Edit the settings for the current private label
      def edit

      end

      private ##################################################

      ##
      # Make sure that the user can do what they are trying to do.
      def load_private_label
        @private_label = Swayze.current_private_label
      end
    end

  end   # Admin module
end     # PrivateLabels module
