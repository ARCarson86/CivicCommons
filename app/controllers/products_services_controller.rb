class ProductsServicesController < ApplicationController
  def index
  end

  def promotion
    @promotion_form_presenter = PromotionFormPresenter.new(:product => params[:product])
  end

  def submit_promotion
    @promotion_form_presenter = PromotionFormPresenter.new(params[:promotion_form_presenter])
    if @promotion_form_presenter.valid?
      Notifier.products_services_promo(
        @promotion_form_presenter.name,
        @promotion_form_presenter.email,
        @promotion_form_presenter.question,
        @promotion_form_presenter.product).deliver

      flash[:notice] = "Thank you contacting us! We'll get back to you shortly!"
      redirect_to products_services_path
    else
      render :action => :promotion
    end
  end
end
