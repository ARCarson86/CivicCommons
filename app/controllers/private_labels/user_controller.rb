module PrivateLabels
  class UserController < PrivateLabels::ApplicationController
    before_filter :get_private_user, only: [:show, :edit]
    before_filter :verify_ownership?, :only => [:edit, :update, :destroy_avatar]

    def show
    end

    def edit
    end

    def update
    end

    private

    def get_private_user
      @person = Swayze.current_private_label.people.find(params[:id])
    end

    def verify_ownership?
      unless(current_person && current_person == Swayze.current_private_label.people.find(params[:id]))
        redirect_to '/'
      end
    end

  end
end # PrivateLabels module
