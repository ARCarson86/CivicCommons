module PrivateLabels
  module Admin
    class SidebarsController < BaseController

      before_filter :get_sidebar

      def show
      end

      def edit
      end

      def get_sidebar
        @sidebar = Swayze.current_private_label.sidebar || Swayze.current_private_label.build_sidebar
      end

    end

  end # Admin module
end # PrivateLabels module
