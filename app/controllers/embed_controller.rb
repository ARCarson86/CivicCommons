class EmbedController < ApplicationController
  layout "embed"

  def index
    respond_to do |f|
      f.html
      f.js
    end
  end
end
