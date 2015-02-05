module PrivateLabels
  module Admin

    class PrivateLabelController < BaseController
      before_filter :load_private_label
      authorize_resource

      ##
      # Edit the settings for the current private label
      def edit
      end

      ##
      # Update the private label settings
      def update
        if @private_label.update_attributes(params[:private_label])
          flash.notice = "Private label settings were updated successfully."
        end
        render :edit
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