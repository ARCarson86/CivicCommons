class RedirectsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def show
    redirect = Redirect.find_by_path! params[:path]
    redirect_to "/#{redirect.destination}"
  end

  private
  def record_not_found
    render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
end
