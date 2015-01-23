module PrivateLabels
  module Admin
    class ConversationsController < BaseController

      def index
        @conversations = @swayze.conversations
      end

      def show
        @conversations = @swayze.conversations.find(params[:id])
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
