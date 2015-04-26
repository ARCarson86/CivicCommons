module PrivateLabels
  class HomepageController < PrivateLabels::ApplicationController
    def show
      @people = Swayze.current_private_label.people
      @conversations = Swayze.current_private_label.conversations.paginate(page: params[:page], per_page: 6)
      @page = Page.home_page.first
      @sidebar = Nokogiri::HTML(Swayze.current_private_label.sidebar.content.html_safe) if Swayze.current_private_label.sidebar
      @meta_info = {
        image_url: Swayze.current_private_label.main_image.url
      }
    end
    def contact
      @contact_us_message = PrivateLabels::ContactUsMessage.new
    end

    def contact_submit
      @contact_us_message = PrivateLabels::ContactUsMessage.new(params[:contact_us_message])
      if @contact_us_message.valid?
        PrivateLabels::Contact.send_contact_email(@contact_us_message).deliver!
      else
        render :contact
      end
    end
  end
end
