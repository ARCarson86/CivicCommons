class PrivateLabel::ConversationsController < PrivateLabel::PlController

	def index
		@conversations = @swayze.conversations
	end

	def show
		@conversation = @swayze.conversations.find(params[:id])
		@contributions = @conversation.contributions
		@newContribrution = Contribution.new
	end
end