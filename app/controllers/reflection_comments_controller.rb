class ReflectionCommentsController < ApplicationController
  layout 'opportunity'

  before_filter :require_user, :only => [:create, :edit, :update, :destroy]
  before_filter :find_conversation_and_reflection
  before_filter :find_comment, :only => [:edit, :update, :destroy]
  before_filter :verify_moderating_ability, :only => [:edit, :update, :destroy]


  def edit
  end

  def update
    if @comment.update_attributes(params[:reflection_comment])
      flash[:notice] = 'This comment has been successfully updated'
      redirect_to conversation_reflection_path(@conversation,@reflection)
    else
      render :action => :edit
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = 'This comment has been successfully deleted'
    redirect_to conversation_reflection_path(@conversation,@reflection)
  end

  def create
    @comment = @reflection.comments.build(params[:reflection_comment])
    @comment.person_id = current_person.id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to conversation_reflection_path @conversation, @reflection }
      else
        format.html { render :template => '/reflections/show' }
      end
    end
  end

  protected

  def find_comment
    @comment = @reflection.comments.find(params[:id])
  end

  def verify_moderating_ability
    if !current_person.admin? && (@comment.person != current_person)
      flash[:notice] = "You're not allowed to view this page"
      redirect_to conversation_reflection_path @conversation, @reflection
    end
  end

  def find_conversation_and_reflection
    @conversation = Conversation.find(params[:conversation_id])
    @reflection = @conversation.reflections.find(params[:reflection_id])
  end


end
