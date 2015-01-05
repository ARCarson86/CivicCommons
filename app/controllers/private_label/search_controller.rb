class PrivateLabel::SearchController < PrivateLabel::PlController
  def results
    search_service = SearchService.new
    private_label = PrivateLabel.where(namespace: request.subdomains.first).first.id

    @models_to_search = [Conversation, Contribution]

    if params[:q] == ''
      flash[:error] = 'You did not search for anything.  Please try again.'
      @results = []
    else
        @results = search_service.fetch_filtered_results(params[:q], params[:filter], :models => @models_to_search, :private_label_id => private_label).paginate(page: params[:page], per_page: 10)
    end
  end

  private
  def determine_model_class(model_string)
    case model_string
    when "contributions"
      return Contribution
    when "conversations"
      return Conversation
    end
  end
end