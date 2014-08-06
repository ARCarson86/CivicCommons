class UnlinkController < ApplicationController
	skip_before_filter :require_no_ssl

  def delete
  	person = current_person
    person.unlink_from_social(params[:provider])
    redirect_to edit_user_path(person), notice: "Your #{params[:provider]} account has been unlinked from your profile."
  end
end