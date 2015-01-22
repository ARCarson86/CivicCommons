class PrivateLabel::Admin::ConversationsController < PrivateLabel::Admin::DashboardController

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