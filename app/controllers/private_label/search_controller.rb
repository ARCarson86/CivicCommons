class SearchController < PrivateLabel::plController
  def results
    search_service = SearchService.new

    if params[:filter] and not determine_model_class(params[:filter]).nil?
      @models_to_search = determine_model_class(params[:filter])
    else
      @models_to_search = [Conversation, Contribution]
    end

    if params[:q] == ''
      flash[:error] = 'You did not search for anything.  Please try again.'
      @results = []
    else
      if(params.key?(:filter))
        @results = search_service.fetch_filtered_results(params[:q], params[:filter], :models => @models_to_search).paginate(page: params[:page], per_page: 10)
      else
        @results = search_service.fetch_results(params[:q], :models => @models_to_search).paginate(page: params[:page], per_page: 10)
      end
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