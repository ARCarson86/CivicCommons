module PrivateLabels
  class SearchController < PlController

    def results
      subdomain = request.subdomains.first
      pl_id = PrivateLabel.where(namespace: subdomain).first.id
      @search = Sunspot.search(Conversation) do
        with(:private_label_id, pl_id)
        keywords(params[:q])
      end
    end
  end

end # PrivateLabels module
