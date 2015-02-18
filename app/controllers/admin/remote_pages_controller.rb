class Admin::RemotePagesController < Admin::DashboardController
  before_filter :get_remote_page, only: [:destroy, :new_conversation, :create_conversation]
  before_filter :build_conversation, only: [:new_conversation, :create_conversation]

  def index
    @remote_pages = RemotePage.all
  end

  def destroy
    @remote_page.destroy
    redirect_to admin_remote_pages_path, notice: 'Your page has been deleted'
  end

  def new_conversation
  end

  def create_conversation
    ActiveRecord::Base.transaction do
      @conversation.save!
      @remote_page.update_attributes conversation: @conversation
      @remote_page.contributions.update_all contributable_type: 'Conversation', contributable_id: @conversation.id
      @presenter.save!
      redirect_to(admin_conversation_path(@conversation), :notice => 'Your conversation has been created!')
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new_conversation
  end

  protected

  def get_remote_page
    @remote_page = RemotePage.find params[:id]
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
