class PrivateLabel::ConversationsController < PrivateLabel::PlController

	def index
		@conversations = @swayze.conversations
	end

	def show
		@conversation = @swayze.conversations.find(params[:id])
		@contributions = @conversation.contributions
		@newContribrution = @conversation.contributions.new
	end
end