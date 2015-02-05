module PrivateLabels
  module ApplicationHelper
    def content_area_column_width_class 
      content_for?(:sidebar) ? 'col-md-8 col-sm-12 col-xs-12' : 'col-md-12'
    end

    def page_classes
      name = params[:controller]

      full_controller_name = name.gsub('/', '-')

      namespaces = name.split('/').reverse.drop(1)
      namespaces << full_controller_name
      return namespaces.join(' ')
    end

    def alert_icon(level)
      case level
      when :warning
        sanitize '<strong>!</strong>'
      when :error
        sanitize '<i class="fa fa-times"></i>'
      else
        sanitize '<i class="fa fa-check"></i>'
      end
    end

    def parameterized_model_name(record)
      record.class.model_name.parameterize
    end

    def private_label_pages
      Page.all
    end
    
    def private_label_page_title
      parts = []
      parts << @meta_info[:title] if @meta_info and @meta_info[:title]
      parts << Swayze.current_private_label.name
      parts.join ' | '
    end
  end
end
