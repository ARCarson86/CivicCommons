class Api::V1::ConversationsController < Api::V1::BaseController
  def show
    @conversation = Conversation.find params[:id]
    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation)

    with_format :html do
      @html_content = render_to_string partial: '/conversations/email_share_body', :locals => { :conversation => @conversation }
    end
  end
end
