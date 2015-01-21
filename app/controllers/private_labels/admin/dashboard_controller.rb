module PrivateLabels
  module Admin
    class DashboardController < PlController
      def show
        @people = @swayze.people
      end
    end

  end # Admin module
end # PrivateLabels module
