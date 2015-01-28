module PrivateLabels
  module Admin
    class SidebarsController < BaseController

      authorize_resource class: 'PrivateLabels::Sidebar'
      before_filter :get_sidebar

      def edit
      end

      def create
        @sidebar = Swayze.current_private_label.create_sidebar private_labels_sidebar_params
        redirect_to private_labels_admin_root_path
      end

      def update
        @sidebar.update_attributes private_labels_sidebar_params
        redirect_to private_labels_admin_root_path
      end

      protected

      def get_sidebar
        @sidebar = Swayze.current_private_label.sidebar || Swayze.current_private_label.build_sidebar
      end

      def private_labels_sidebar_params
        params.require(:private_labels_sidebar).permit(:content)
      end

    end
  end # Admin module
end # PrivateLabels module
