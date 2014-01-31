class Ability
  include CanCan::Ability
  
  AVAILABLE_ADMIN_CONTROLLER_ROLES = [
      :admin_dashboard,
      :admin_featured_homepages ,
      :admin_featured_opportunities ,
      :admin_articles ,
      :admin_conversations ,
      :admin_metro_regions ,
      :admin_topics ,
      :admin_issues ,
      :admin_people ,
      :admin_content_items ,
      :admin_blog_posts ,
      :admin_news_items ,
      :admin_radio_shows ,
      :admin_content_templates ,
      :admin_curated_feeds ,
      :admin_surveys ,
      :admin_email_restrictions ,
      :admin_widget_stats, 
      :admin_content_item_links, 
      :admin_curated_feed_items,
      :admin_managed_issue_pages,
      :admin_regions,
      :admin_user_registrations,
      :admin_redirects
      ]
    
  
  def initialize(user)
    
    # CanCan is curently used only on the admin controller.
    if user.admin?
      can :manage,  :all
    elsif user.blog_admin?
      can :manage,  :admin_dashboard
      can :manage, ContentItem
      can :manage, :admin_blog_posts
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
