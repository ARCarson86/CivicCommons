class PrivateLabels::SearchController < PrivateLabels::PlController

  def results
    swayze = @swayze
    @search = Sunspot.search [Conversation, Contribution] do
      with(:private_label_id, swayze.private_label_id)
      fulltext params[:q] do
        highlight :summary, :content, fragment_size: 200, max_snippets: 1
      end
      paginate page: params[:page], per_page: 10
    end
  end

end
