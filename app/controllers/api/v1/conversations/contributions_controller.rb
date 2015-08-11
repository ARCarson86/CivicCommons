class Api::V1::Conversations::ContributionsController < Api::V1::BaseController
  load_resource :conversation
  load_and_authorize_resource :contribution, through: [:conversation]

  before_filter :update_embedly_attributes, only: [:create, :update]

  def index
    @contributions = @contributions.where(parent_id: nil).includes(:person, children: [:person]).order("created_at DESC").paginate(page: params[:page], per_page: 20)
    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, current_person)
  end

  def create
    @contribution.confirmed = true
    @contribution.attachment_file_name = attachment_file_name if @contribution.attachment.present?
    @contribution.save!
    render 'show'
  end

  def update
    empty_user unless current_person
    @contribution.update_attributes params[:contribution]
    render 'show'
  end

  def destroy
    if @contribution.destroy
      render json: {
        success: true
      }
    end
  end

  def flag
    Tos.send_violation_complaint (current_person || Person.new), @contribution, (params[:reason] || 'No Reason Given')
    render json: {
      success: true
    }
  end

  def toggle_rating
    @rating_descriptor = RatingDescriptor.find_by_title(params[:title])
    @rating_group = RatingGroup.toggle_rating!(current_person, @contribution, @rating_descriptor)

    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, current_person)
    @contribution.touch
    render json: { success: true, ratings: @ratings }
  end

  def moderate
    @contribution.moderate_content(params[:reason], current_person)
    render :show
  end

  private

  def update_embedly_attributes
    unless @contribution.url.blank?
      embedly = EmbedlyService.new
      embedly.fetch_and_update_attributes(@contribution)
    end
  end

  def attachment_file_name
    case @contribution.attachment_content_type
    when "image/jpeg"
      "image.jpg"
    when "image/jpg"
      "image.jpg"
    when "image/png"
      "image.png"
    else
      "image.jpg"
    end
  end
end
