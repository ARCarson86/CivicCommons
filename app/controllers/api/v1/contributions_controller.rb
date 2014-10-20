class Api::V1::ContributionsController < Api::V1::BaseController
  load_resource :conversation
  load_resource :remote_page
  load_and_authorize_resource :contribution, through: [:conversation, :remote_page]

  before_filter :update_embedly_attributes, only: [:create, :update]

  def index
    @contributions = @contributions.includes(:person, children: [:person]).order("created_at DESC").paginate(page: params[:page], per_page: 20)
  end

  def create
    @contribution.save!
    render 'show'
  end

  def update
    empty_user unless current_person
    @contribution.update_attributes params[:contribution]
    render 'show'
  end

  def flag
    Tos.send_violation_complaint (current_person || Person.new), @contribution, (params[:reason] || 'No Reason Given')
    render json: {
      success: true
    }
  end

  private

  def update_embedly_attributes
    unless @contribution.url.blank?
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(@contribution)
    end
  end


end
