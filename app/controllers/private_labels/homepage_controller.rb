module PrivateLabels
  class HomepageController < ApplicationController

    def show
      @people = Swayze.current_private_label.people
      @conversations = Swayze.current_private_label.conversations
    end
	def contact

	end

	def contact_submit

	end
  end

end # PrivateLabels module
