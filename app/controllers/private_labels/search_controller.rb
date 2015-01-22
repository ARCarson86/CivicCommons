class PrivateLabels::SearchController < PrivateLabels::PlController

  def results
    swayze = @swayze
    @search = Sunspot.search(Conversation) do
      with(:private_label_id, swayze.private_label_id)
      keywords(params[:q])
    end
  end

end
