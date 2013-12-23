class TosController < ApplicationController
  before_filter :require_user

  def new
    @contribution = params[:contribution_id]

    respond_to do |format|
      if request.xhr?
        format.html { render :partial => 'tos_contribution_form', :layout => false }
      else
        format.html { render :partial => 'tos_contribution_form'}
      end
    end
  end

  def create
    reason = params[:tos][:reason]
    @contribution = Contribution.find(params[:contribution_id])
    if !reason.blank? && @contribution
      result = Tos.send_violation_complaint(current_person, @contribution, reason)
    end
    # Rails.logger.info("TOS Result:#{result}")

    respond_to do |format|
      unless reason.blank?
        format.html { redirect_to conversation_path(id: @contribution.conversation_id), notice: "Thank you! You're helping to make your community stronger!" }
      else
        format.html { render :partial => 'tos_contribution_form'}
        flash[:notice] = "Please include a reason."
      end
    end
  end

end
