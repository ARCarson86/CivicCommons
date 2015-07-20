class Api::V1::ConversationsController < Api::V1::BaseController
  def show
    @conversation = Conversation.find params[:id]
    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation)
  end
end
