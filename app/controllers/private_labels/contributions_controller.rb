module PrivateLabels
  class ContributionsController < PlController

    before_filter :get_conversation
    def index
      @contributions = @swayze.contributions
    end

    def show
      @contribution = @swayze.contributions.find(params[:id])
    end

    def new
      @contribution = Contribution.new()
    end

    def create
      @contribution = @conversation.contributions.new(params[:contribution])
      @contribution.person = current_person
      @contribution.save validate: false # TODO: Fix validation
    end

    def tos
      @contribution = @conversation.contributions.find(params[:id])
      # TODO: do the flagging
    end

    def tos_flag
      @contribution = @conversation.contributions.find(params[:id])
    end

    protected ##################################################

    def get_conversation
      @conversation = @swayze.conversations.find(params[:conversation_id])
    end
  end

end # PrivateLabels module
