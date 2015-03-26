class Api::V1::ConversationsController < Api::V1::BaseController
  def show
    @conversation = Conversation.find params[:id]
  end
end
