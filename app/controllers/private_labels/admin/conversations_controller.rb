module PrivateLabels
  module Admin
    class ConversationsController < BaseController

      def index
        @conversations = Swayze.current_private_label.conversations
      end

      def show
        @conversations = Swayze.current_private_label.conversations.find(params[:id])
      end

      def new
        @conversation = Conversation.new()
      end

      def create
        @conversation = Conversation.new(params[:conversation])
      end
    end

  end # Admin module
end # PrivateLabels module
