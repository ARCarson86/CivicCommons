class Admin::ConversationsPeopleController < Admin::DashboardController

  authorize_resource :class => :admin_conversations_people

  def index
    @conversation = Conversation.includes(conversations_people: [:person] ).find(params[:conversation_id])
  end

  def new
    if params[:letter] == 'all'
      @letter = params[:letter]
      @queried_letter = nil
    else
      @letter = params[:letter] || 'A'
      @queried_letter = @letter
    end
    @people = Person.find_confirmed_order_by_last_name(@queried_letter)

    @conversation = Conversation.find(params[:conversation_id])
  end

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @moderator = ConversationsPerson.new(conversation_id:@conversation.id, person_id:params[:person_id])
    if @moderator.save
      redirect_to admin_conversation_conversations_people_path(params[:conversation_id]) #@conversation)
    else
      @conversations = Conversation.all
      render :action => :new
    end
  end

  def destroy
    @moderator = ConversationsPerson.find(params[:id])
    @moderator.destroy

    redirect_to admin_conversation_conversations_people_path(params[:conversation_id])
  end

end
