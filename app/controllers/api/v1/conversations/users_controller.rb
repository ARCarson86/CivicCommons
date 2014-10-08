class Api::V1::Conversations::UsersController < Api::V1::BaseController
  before_filter :load_contributable

  def index
    @users = @contributable.contributors
  end

  def show
    @user = @contributable.contributors.find params[:id]
  end

  private
    def load_contributable
      klass = [Conversation, RemotePage].detect { |c| params["#{c.name.underscore}_id"]}
      @contributable  = klass.find(params["#{klass.name.underscore}_id"])
    end
end
