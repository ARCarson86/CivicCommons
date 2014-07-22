class Api::V1::ContributionsController < Api::V1::BaseController
  before_filter :get_conversation

  def index
    @contributions = @conversation.top_level_contributions.includes(:person, children: [:person]).order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end

  private
  def get_conversation
    @conversation = Conversation.find params[:conversation_id]
  end

end
