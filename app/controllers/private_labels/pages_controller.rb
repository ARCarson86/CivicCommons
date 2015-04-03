module PrivateLabels
  class PagesController < ApplicationController
    load_and_authorize_resource class: 'PrivateLabels::Page'

    def show
      @meta_info = {
        title: @page.title,
        keywords: @page.meta_keywords,
        description: @page.meta_description
      }
    end

  end
end # PrivateLabels module
