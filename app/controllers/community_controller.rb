class CommunityController < ApplicationController

  def index
    @issue = Issue.find(params[:issue_id]) if params[:issue_id]
    ordered_people
    filtered_people
    paginated_people
    @regions = Region.all
  end

  private
  def ordered_people
    @order = params[:order] || 'newest-member'
    case @order
    when 'alphabetical'
      @subtitle = 'Alphabetical'
      @community = @issue.present? ? @issue.order_by_alpha_users(params[:letter]) : Person.find_confirmed_order_by_last_name(params[:letter])
    when 'active-member'
      @subtitle = 'Most Active'
      @community = @issue.present? ? @issue.most_active_users : Person.find_confirmed_order_by_most_active
    else
      @subtitle = 'Newest Members'
      @community = @issue.present? ? @issue.most_newest_users : Person.find_confirmed_order_by_recency
    end
  end

  def filtered_people
    @current_filter = params[:filter] || 'all'
    case @current_filter
    when 'all'
      @community
    when 'people'
      @community = @community.only_people
    when 'organizations'
      @community = @community.only_organizations
    end
  end

  def paginated_people
    @community = @community.paginate(:page => params[:page], :per_page => 16)
  end

end
