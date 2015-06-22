class Admin::RemotePages::ConversationsController < Admin::DashboardController
  before_filter :get_remote_page, only: [:new, :create]
  before_filter :build_conversation, only: [:new, :create]

  def new
  end

  def create
    ActiveRecord::Base.transaction do
      @conversation.save!
      @remote_page.update_attributes conversation: @conversation
      @remote_page.contributions.update_all contributable_type: 'Conversation', contributable_id: @conversation.id
      @presenter.save!
      redirect_to(admin_conversation_path(@conversation), :notice => 'Your conversation has been created!')
    end
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  protected

  def get_remote_page
    @remote_page = RemotePage.find params[:remote_page_id]
  end

  def build_conversation
    attributes = {
      title: @remote_page.title,
      page_title: @remote_page.title,
      meta_description: @remote_page.description,
      summary: @remote_page.description,
      link: @remote_page.url,
      person: current_person
    }
    attributes.merge!(params[:conversation].symbolize_keys) if params[:conversation]
    @conversation = @remote_page.build_conversation attributes
    @presenter = IngestPresenter.new(@conversation)
  end

end
