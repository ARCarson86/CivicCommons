class EmbedController < ApplicationController
  layout "embed"

  def index
    # respond_to do |f|
    #   f.html
    #   f.js
    # end
  end

  def test_comments
    @remote_page = RemotePage.where(conversation_id: nil).first
    render layout: "application"
  end

  def test_conversation
    @remote_page = RemotePage.where("conversation_id is not null").first
    render layout: "application"
  end
end
