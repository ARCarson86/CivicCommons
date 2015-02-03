module PrivateLabels
  module Admin
    class SidebarsController < BaseController

      before_filter :get_sidebar
      authorize_resource class: 'PrivateLabels::Sidebar'

      def edit
      end

      def create
        @sidebar = Swayze.current_private_label.create_sidebar sidebar_params
        redirect_to private_labels_admin_root_path
      end

      def update
        @sidebar.update_attributes sidebar_params
        redirect_to private_labels_admin_root_path
      end

      protected

      def get_sidebar
        @sidebar = Swayze.current_private_label.sidebar || Swayze.current_private_label.build_sidebar
      end

      def sidebar_params
        params.require(:sidebar).permit(:content)
      end

    end
  end # Admin module
end # PrivateLabels module
