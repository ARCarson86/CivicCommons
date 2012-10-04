class HomepageController < ApplicationController
  layout 'homepage'

  def show
    @most_recent_conversation  = Conversation.latest_created.limit(1)
    @most_active_conversation  = Conversation.most_active(filter:@most_recent_conversation).limit(1)
    @most_recommended_conversation = Conversation.recommended.limit(1)

    @featured_opportunities = FeaturedOpportunity.all

    @recent_items = Activity.most_recent_activity_items(limit: 3)
    @recent_blog_posts = ContentItem.recent_blog_posts.limit(3)

    respond_to do |format|
      format.html
    end
  end

end
