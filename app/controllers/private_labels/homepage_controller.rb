module PrivateLabels
  class HomepageController < ApplicationController

    def show
      @people = Swayze.current_private_label.people
      @conversations = Swayze.current_private_label.conversations.paginate(page: params[:page], per_page: 6)
      @page = Page.home_page.first
      @sidebar = Nokogiri::HTML(Swayze.current_private_label.sidebar.content.html_safe)
      @meta_info = {
        image_url: Swayze.current_private_label.main_image.url
      }
    end
	def contact

	end

	def contact_submit

	end
  end

end # PrivateLabels module
