module PrivateLabels
  module Admin
    class PagesController < BaseController
      before_filter :get_page, only: [:create, :update]
      load_and_authorize_resource class: 'PrivateLabels::Page'

      def index
      end

      def show
        render :edit
      end

      def new
      end

      def create
        if @page.save
          redirect_to private_labels_admin_pages_path
        else
          render :new
        end
      end

      def edit
      end

      def update
        if @page.save
          redirect_to private_labels_admin_pages_path
        else
          render :edit
        end
      end

      def destroy
        if (@page.destroy)
          redirect_to private_labels_admin_pages_path, notice: "#{@page.title} has been deleted"
        else
          redirect_to private_labels_admin_pages_path, notice: "There was an error deleting the page"
        end
      end

      protected

      def get_page
        if (params[:id])
          @page = Page.accessible_by(current_ability).find params[:id]
          @page.assign_attributes update_params
        else
          @page = Page.accessible_by(current_ability).new create_params
        end
      end

      def page_params
        params.require(:page).permit :title, :content, :sidebar
      end

      def create_params
        page_params
      end

      def update_params
        page_params
      end

    end
  end # Admin module
end # PrivateLabels module
