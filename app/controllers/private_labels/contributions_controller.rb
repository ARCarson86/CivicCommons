module PrivateLabels
  class ContributionsController < PrivateLabels::ApplicationController
    before_filter :get_conversation, except: [:index]
    before_filter :require_user, only: [ :create ]

    def index
      @contributions = Swayze.current_private_label.contributions
    end

    def show
      @contribution = Swayze.current_private_label.contributions.find(params[:id])
    end

    def new
      @contribution = Contribution.new()
    end

    def create
      @contribution = @conversation.contributions.new(params[:contribution])
      @contribution.person = current_person
      @contribution.save validate: false # TODO: Fix validation
      redirect_to @conversation, notice: 'Contribution Created Successfully'
    end

    def tos
      @contribution = @conversation.contributions.find(params[:id])
      # TODO: do the flagging
    end

    def tos_flag
      @contribution = @conversation.contributions.find(params[:id])
    end

     def moderate
      @contribution = @conversation.contributions.find(params[:id])
    end

    def moderated
      @contribution = @conversation.contributions.find(params[:id])
      @contribution.moderate_content(params, current_person)
      redirect_to conversation_path(@conversation)
    end

    protected ##################################################

    def get_conversation
      @conversation = Swayze.current_private_label.conversations.find(params[:conversation_id])
    end

  end
end # PrivateLabels module
