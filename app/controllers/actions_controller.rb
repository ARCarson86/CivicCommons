class ActionsController < ApplicationController
  layout 'opportunity'

  before_filter :find_conversation

  def index
    @actions = @conversation.actions.order('id DESC')

    if (params[:type] == 'petition')
      @actions = @actions.where(actionable_type:"Petition")
    end
    if (params[:type] == 'ballot')
      @actions = @actions.where(actionable_type:"Survey")
    end
    @participants = @conversation.action_participants
  end

protected
  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

end
