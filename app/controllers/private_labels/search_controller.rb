module PrivateLabels
  class SearchController < PrivateLabels::ApplicationController

    def results
      @search = Sunspot.search [Conversation, Contribution] do
        with(:private_label_id, Swayze.current_private_label.id)
        fulltext params[:q] do
          highlight :summary, :content, fragment_size: 200, max_snippets: 1
        end
        paginate page: params[:page], per_page: 10
      end
    end

  end
end # PrivateLabels module
