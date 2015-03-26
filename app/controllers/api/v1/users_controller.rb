class Api::V1::UsersController < Api::V1::BaseController
  before_filter :load_contributable, only: [:index, :show]
  def me
    @user = current_person
    empty_user if @user.nil?
  end

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
