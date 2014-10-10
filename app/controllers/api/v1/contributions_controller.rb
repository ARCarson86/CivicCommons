class Api::V1::ContributionsController < Api::V1::BaseController
  before_filter :load_contributable
  load_resource :conversation
  load_resource :remote_page
  load_and_authorize_resource :contribution, through: [:contribution, :remote_page], only: [:create, :update]

  def index
    @contributions = @contributable.top_level_contributions.includes(:person, children: [:person]).order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end

  def create
    empty_user unless current_person
    @contribution = current_person.contributions.new params[:contribution]
    @contributable.contributions << @contribution
    @contribution.save!
    render 'show'
  end

  def update
    empty_user unless current_person
    @contribution.update_attributes params[:contribution]
    render 'show'
  end

  private

    def load_contributable
      klass = [Conversation, RemotePage].detect { |c| params["#{c.name.underscore}_id"]}
      @contributable  = klass.find(params["#{klass.name.underscore}_id"])
    end

end
