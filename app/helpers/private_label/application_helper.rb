module PrivateLabel::ApplicationHelper
	def content_area_column_width_class 
	 	content_for?(:sidebar) ? 'col-md-8 col-sm-8 col-xs-12' : 'col-md-12'
	end

	def page_classes
		params[:controller].gsub('/', '-')
	end
end