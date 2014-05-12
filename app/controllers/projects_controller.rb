class ProjectsController < ApplicationController
  layout 'category_index'

  # GET /projects
  def index
    @projects = Issue.filter_metro_region(default_region).managed_issue.published.custom_order.paginate(:page => params[:page], :per_page => 20)
    @recent_items = Activity.most_recent_activity_items(limit: 3)
    @top_metro_regions = MetroRegion.top_metro_regions(5)
  end
end