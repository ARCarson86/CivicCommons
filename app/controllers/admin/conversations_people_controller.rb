class Admin::ConversationsPeopleController < Admin::DashboardController

  authorize_resource :class => :admin_conversations_people

  def show
    @moderator = ConversationsPerson.find(params[:id])
  end

  def edit
    @moderator = ConversationsPerson.find(params[:id])
    @conversations = Conversation.all
    @users = Person.all
  end

  def index
    @moderators = ConversationsPerson.all
  end

  def new
    @moderator = ConversationsPerson.new
    @conversations = Conversation.all
    @users = Person.all
  end

  def create
    @moderator = ConversationsPerson.new(params[:conversations_person])
    if @moderator.save
      redirect_to [:admin,@moderator]
    else
      @conversations = Conversation.all
      render :action => :new
    end
  end

  def update
    @moderator = ConversationsPerson.find(params[:id])
    @moderator.attributes = (params[:conversations_person])
    if @moderator.save
      redirect_to [:admin,@moderator]
    else
      @conversations = Conversation.all

      render :action => :edit
    end
  end

  def destroy
    @moderator = ConversationsPerson.find(params[:id])
    @moderator.destroy
    redirect_to :action => :index
  end

  def change_conversation_selection
    @conversation = Conversation.find(params[:conversation_id])
    @contributions = @conversation.contributions
    @actions = @conversation.actions
    @reflections = @conversation.reflections
  end

protected
  def build_featured_opportunity_items
    @moderator.contributions.build if @moderator.contributions.length < 1
    @moderator.actions.build if @moderator.actions.length < 1
    @moderator.reflections.build if @moderator.reflections.length < 1
  end
end
