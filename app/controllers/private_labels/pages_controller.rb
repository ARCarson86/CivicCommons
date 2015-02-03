module PrivateLabels
  class PagesController < ApplicationController
    load_and_authorize_resource class: 'PrivateLabels::Page'

    def show
    end

  end
end # PrivateLabels module
