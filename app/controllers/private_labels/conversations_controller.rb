module PrivateLabels
  class ConversationsController < ApplicationController

    def index
      @conversations = @swayze.conversations
    end

    def show
      @conversation = @swayze.conversations.find(params[:id])
      @contributions = @conversation.contributions
      @newContribrution = Contribution.new
    end

  end
end # PrivateLabels module
