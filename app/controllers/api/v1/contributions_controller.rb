class Api::V1::ContributionsController < ApplicationController
  before_filter :get_conversation

  def index
    @contributions = @conversation.top_level_contributions.includes(:person, children: [:person]).paginate(page: params[:page], per_page: 10);
  end

  private
  def get_conversation
    @conversation = Conversation.find params[:conversation_id]
  end

end
