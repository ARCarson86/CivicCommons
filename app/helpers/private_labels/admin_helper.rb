module PrivateLabels
  module AdminHelper
    def admin_sidebar_link_to(name, path)
      content_tag :li, link_to(name, path), class: current_page?(path) ? 'active' : ''
    end
  end
end
