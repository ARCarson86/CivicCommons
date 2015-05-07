module PrivateLabels
  module Admin
    class ConversationsController < BaseController
      load_and_authorize_resource

      def index
      end

      def edit
      end

      def update
        if @conversation.update_attributes(params[:conversation])
          redirect_to private_labels_admin_conversations_path, notice: 'Conversation updated successfully!'
        else
          render :edit
        end
      end

      def show
      end

      def new
      end

      def create
        @conversation.person = current_person
        if @conversation.save
          redirect_to private_labels_admin_conversations_path, notice: 'Conversation created!'
        else
          render :edit
        end
      end

      def destroy
        @conversation.destroy
        redirect_to private_labels_admin_conversations_path, notice: 'Conversation was deleted!'
      end
    end

  end # Admin module
end # PrivateLabels module
