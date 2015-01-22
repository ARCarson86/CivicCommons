module PrivateLabels
  module ApplicationHelper
    def content_area_column_width_class 
      content_for?(:sidebar) ? 'col-md-8 col-sm-8 col-xs-12' : 'col-md-12'
    end

    def page_classes
      params[:controller].gsub('/', '-')
    end

    def alert_icon(level)
      case level
      when :notice
        sanitize '<i class="icon icon-ok"></i>'
      when :warning
        sanitize '<strong>!</strong>'
      when :error
        sanitize '<i class="icon icon-remove"></i>'
      end
    end
  end
end
