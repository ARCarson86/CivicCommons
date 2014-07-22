class Api::V1::Conversations::UsersController < Api::V1::BaseController
  before_filter :get_conversation
  def index
    @users = @conversation.contributors
  end

  def show
    @user = @conversation.contributors.find params[:id]
  end

  private
  def get_conversation
    @conversation = Conversation.find params[:conversation_id]
  end
end
