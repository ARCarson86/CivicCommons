module PrivateLabels
  module AdminHelper
    ##
    # Generates and returns the HTML necessary for creating a 
    # list item containing a link for the Private Label Admin
    # sidebar.
    #
    # CanCan authorization will be checked and, if the current
    # user doesn't have the permisssions to manage the object
    # or class, then nil is returned.
    #
    # @param [String] name The text for inside the link
    #
    # @param [String] path The path for the href value of the link
    #
    # @param [Class,Object] auth_object The object to test for 
    #   authorization using CanCan.
    def admin_sidebar_link_to(name, path, auth_object)
      if can? :manage, auth_object
        content_tag :li, link_to(name, path), class: current_page?(path) ? 'active' : ''
      else
        nil
      end
    end

    def last_sign_in(person)
      return "Never" if person.nil? || person.last_sign_in_at.nil?

      person.last_sign_in_at.to_formatted_s(:long_friendly)
    end
  end
end
