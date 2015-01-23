module PrivateLabels
  module Admin

    ##
    # The superclass for all private label admin controllers
    class BaseController < PlController
      prepend_before_filter :authenticate_person!
      before_filter :check_for_admin

      private ##################################################

      ##
      # Ensure that the user is an administrator. If not, they should not
      # have any access to this controller.
      def check_for_admin
        raise SecurityError.new unless @swayze.admins.include?(current_person)
      end
    end

  end
end
