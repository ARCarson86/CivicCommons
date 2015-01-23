module PrivateLabels
  class ConversationsController < ApplicationController
    before_filter :find_conversation, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource

    def index
    end

    def edit

    end

    def show
      @contributions = @conversation.contributions
      @newContribrution = Contribution.new
    end

    protected

    def find_conversation
      @conversation = Conversation.accessible_by(current_ability).find params[:id]
    end

  end
end # PrivateLabels module
