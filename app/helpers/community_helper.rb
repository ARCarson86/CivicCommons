module CommunityHelper
  def community_site_filter_link(order)
    issue = @issue ? @issue.becomes(Issue) : nil
    case order
    when 'alphabetical'
      title = 'Alphabetical'
    when 'newest-member'
      title = 'Newest Members'
    when 'active-member'
      title = 'Most Active'
    when 'organizations'
      title = 'Organizations'
    when 'people'
      title = 'People'
    end
    merged_params =  request.parameters.except(:controller, :action).merge({:order => (@order == order ? nil : order), :page => params[:page]})
    css_class = @order == order ? 'active' : nil 
    link_to title, polymorphic_path([issue,:community], merged_params), :id => order, :class => css_class 
  end
  
  def community_site_people_filter_link(filter)
    issue = @issue ? @issue.becomes(Issue) : nil
    active = @current_filter == filter
    css_class = active ? 'active' : ''
    case filter
    when 'people'
      filter_name = 'People Only'
    when 'organizations'
      filter_name = 'Organizations Only'
    else
      filter_name = 'People & Organizations'
    end
    merged_params = request.parameters.except(:controller, :action).merge({:filter => filter, :page=>nil})
    link_to raw("<span>#{filter_name}</span>"), polymorphic_path([issue,:community], merged_params), :class=> css_class
  end

end
