class Admin::FeaturedHomepageController < Admin::DashboardController
  
  authorize_resource :class => :admin_featured_homepages
  
  def index
    @items = []

    conversations = Conversation.includes(:homepage_featured).latest_created
    @items |= conversations.collect do |conversation|
      {
        created_at: conversation.created_at,
        featured: conversation.featured?,
        id: conversation.id,
        custom_image: conversation.custom_image?,
        title: conversation.title,
        type: conversation.class.to_s,
        url: admin_conversation_path(conversation)
      }
    end

    issues = Issue.includes(:homepage_featured).most_recent
    @items |= issues.collect do |issue|
      {
        created_at: issue.created_at,
        featured: issue.featured?,
        id: issue.id,
        custom_image: issue.custom_image?,
        title: issue.name,
        type: issue.class.to_s,
        url: admin_issue_path(issue)
      }
    end
  end

  def update
    item = params[:type].constantize.find(params[:id])
    if params[:featured]
      item.homepage_featured = HomepageFeatured.create unless item.featured?
    else
      item.homepage_featured.destroy if item.featured?
    end
    flash[:notice] = "Successfully updated #{ params[:type] } #{ params[:id] } to #{ (!params[:featured].nil?).to_s }."

    respond_to do |format|
      format.html { redirect_to admin_featured_homepage_index_path }
    end
  end
end