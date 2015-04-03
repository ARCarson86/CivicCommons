module PrivateLabels
  class ConversationsController < ApplicationController
    before_filter :find_conversation, only: [:show, :edit, :update, :destroy]
    before_filter :set_meta, only: [:show]
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

    def set_meta
      @meta_info = {
        title: @conversation.title,
        description: @conversation.meta_description,
        keyswords: @conversation.meta_tags,
        image_url: @conversation.image.url()
      }
    end

  end
end # PrivateLabels module
