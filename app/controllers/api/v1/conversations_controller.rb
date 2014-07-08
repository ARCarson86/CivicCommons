class Api::V1::ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find params[:id]
  end
end
