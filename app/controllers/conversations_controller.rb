class ConversationsController < ApplicationController
  layout 'opportunity', :except => :index
  before_filter :force_friendly_id, :only => :show
  before_filter :require_user, :only => [
    :new,
    :create,
    :toggle_rating,
    :create_from_blog_post,
    :create_from_radioshow,
  ]

  ################################################################################
  # Conversation Modal Methods - BEGIN
  ################################################################################
  def agree_to_be_civil_modal
    render :partial => 'agree_to_be_civil_modal', :layout => nil
  end

  def permission_to_use_image_modal
    render :partial => 'permission_to_use_image_modal', :layout => nil
  end

  def take_action
    @conversation = Conversation.find(params[:id])
    render :partial => 'take_conversation_action', :layout => nil
  end
  ################################################################################
  # Conversation Modal Methods - END
  ################################################################################

  # Topic Set Up
  def topic_setup
    # List of Valid Topics and Number of Conversations Each Topic Has
    @topics = Topic.where("topics.id != 9").filter_metro_region(default_region)
    @topics = @topics.including_conversations if @topics.present?

    # The Current Topic and It's Subtitle
    @current_topic = Topic.find_by_id(params[:topic])
    @subtitle = @current_topic.name if @current_topic

    @search = @current_topic ? @current_topic.conversations : Conversation
  end

  # GET /conversations
  def index
    topic_setup

    @recommended = @search.filter_metro_region(default_region).recommended.limit(3)
    if default_region == cc_metro_region || default_region.blank? #&& !@current_topic.present?
      @active = @search.filter_metro_region(default_region).most_active.limit(6)
      @recent = @search.filter_metro_region(default_region).latest_created.limit(6)
    else
      @all_conversations = @search.filter_metro_region(default_region).paginate(:page => params[:page], :per_page => 12)
    end

    @top_metro_regions = MetroRegion.top_metro_regions(5)

    @recent_items = Activity.most_recent_activity_items(limit: 3)
    render :index, :layout => 'category_index'
  end

  # GET /conversations/recommended
  # GET /conversations/active
  # GET /conversations/recent
  def filter
    topic_setup

    @filter = params[:filter]
    @conversations = @search.filter_metro_region(default_region).filtered(@filter).paginate(:page => params[:page], :per_page => 12)
    @top_metro_regions = MetroRegion.top_metro_regions(5)

    @recent_items = Activity.most_recent_activity_items(limit: 3)
    render :filter, :layout => 'category_index'
  end

  # GET /conversations/rss
  def rss
    @conversations = Conversation.where("created_at >= '#{1.month.ago}'").order(:created_at => :desc)
    respond_to do |format|
      format.html { redirect_to(conversations_url) }
      format.xml
    end
  end

  # GET /conversations/1
  def show
    @new_conversation = params[:conversation_created] ? true : false
    @conversation = Conversation.includes(:issues).find(params[:id])
    @conversation.visit!(current_person.id) if current_person
    @contributions = @conversation.contributions.includes(:rating_groups, :person).confirmed.where(parent_id: nil).order("created_at DESC")
    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, current_person)

    # Build rating totals into contribution
    # @contributions.each do |c|
    #   c.ratings       #=> {'some-descriptor' => {:total => 5, :person => true}, 'some-other' => 0, 'and-again' => 1}
    # end
    @top_level_contributions = @contributions.select{ |c| c.top_level_contribution? }
    # grab all direct contributions to conversation that aren't TLC
    @conversation_contributions = @contributions.select{ |c| !c.top_level_contribution? && c.parent_id.nil? }

    @top_level_contribution = @conversation.contributions.new # for conversation comment form
    @tlc_participants = @top_level_contributions.collect{ |tlc| tlc.owner }

    @latest_contribution = @conversation.confirmed_contributions.most_recent.first

    @recent_items = @conversation.activities.where("item_type NOT IN (?)", ["RatingGroup", "Reflection", "ReflectionComment"]).order("created_at DESC").limit(30)

    # The Participants in a Conversation               | Moved from View to Controller. TODO: Move to model
    @conversation_participants = @conversation.participants.select{ |p| !@tlc_participants.include?(p.id) }

    setup_meta_info(@conversation)

    respond_to do |format|
      format.html{ render :show }
      format.embed do
        html = render_to_string
        json = {
          :html => html,
          :js => [ActionController::Base.helpers.asset_path('conversations/show_embed.js')]
          }
        render_widget(json)
      end
      format.any{ render :show}
    end
  end

  def embed
    @conversation = Conversation.find(params[:id])
    render :layout => 'application'
  end

  def activities
    @page = params[:page].present? ? params[:page].to_i : 1
    @hide_container = params[:hide_container]
    @per_page = 5
    @offset = @per_page * (@page - 1)

    @conversation = Conversation.find(params[:id])

    # Added 1 to @per_page to see if there is a next page
    @recent_items = Activity.most_recent_activity_items(conversation:@conversation, limit:@per_page + 1, offset:@offset, exclude_conversation:true)
    @next_page = @recent_items.length > @per_page

    # if there is a next page, pop the last item because it was temporarily used to see if there is a next page.
    @recent_items.pop if @next_page

    respond_to do |format|
      format.embed do
        @embed = true # needed to differentiate the truncation limit on the activity content length when displaying as an embed
        html = render_to_string
        json = {
          :html => html,
          :page => @page,
          :next_page => @next_page,
          :js => [ActionController::Base.helpers.asset_path('conversations/activities.embed.js')]
          }
        render_widget(json)
      end
    end
  end

  def node_conversation
    @contribution = Contribution.find(params[:id])
    @contributions = @contribution.descendants.confirmed.includes(:person)
    @contribution.visit!((current_person.nil? ? nil : current_person.id))

    respond_to do |format|
      format.js { render :partial => "conversations/node_conversation", :layout => false}
      format.html { render :partial => "conversations/node_conversation", :layout => false}
    end
  end

  def node_permalink
    contribution = Contribution.find(params[:id])
    @contributions = contribution.self_and_ancestors
    @top_level_contribution = @contributions.root
    contribution.visit!((current_person.nil? ? nil : current_person.id))

    respond_to do |format|
      format.js
    end
  end

  # GET /conversations/new
  def new
    get_content_item(params)
    @conversation = Conversation.new
    render :new, :layout => 'category_index'
  end

  # GET /conversations/1/edit
  # NOT IMPLEMENTED YET, I.E. NOT ROUTEABLE
  def edit
    @conversation = Conversation.find(params[:id])
  end

  # POST /conversations
  def create
    prep_convo(params)

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to(conversation_path(@conversation.id, :conversation_created => true), :notice => "Thank you! You're helping to make your community stronger!") }
      else
        format.html { render :new, :layout => 'category_index' }
      end
    end
  end

  # PUT /conversations/blog/:id
  def create_from_blog_post
    @blog_post = ContentItem.find(params[:id])
    if request.xhr?
      render partial: 'shared/redirect_after_xhr', locals: { url: blog_url(@blog_post) }
    elsif @blog_post.conversation
      redirect_to conversation_url(@blog_post.conversation)
    else
      params[:conversation][:summary] = "<em>This is a conversation about a blog post from #{@blog_post.author.name}: <a href=\"#{blog_url(@blog_post)}\">#{@blog_post.title}</a></em><br/><br/>#{@blog_post.summary}"
      params[:conversation][:title] = "Blog Post: #{@blog_post.title}"
      params[:conversation][:zip_code] = "ALL"
      prep_convo(params)
      if @conversation.save
        @blog_post.conversation = @conversation
        @blog_post.save
        redirect_to conversation_path(@conversation)
      else
        render 'blog/show'
      end
    end
  end

  # PUT /conversations/radio/:id
  def create_from_radioshow
    @radioshow = ContentItem.find(params[:id])
    if request.xhr?
      render partial: 'shared/redirect_after_xhr', locals: { url: radioshow_url(@radioshow) }
    else
      params[:conversation][:summary] = "<em>This is a conversation about The Civic Commons Radio <a href=\"#{radioshow_url(@radioshow)}\">#{@radioshow.title}</a></em><br/><br/>#{@radioshow.summary}"
      params[:conversation][:title] = "The Civic Commons Radio #{@radioshow.title}"
      params[:conversation][:zip_code] = "ALL"
      prep_convo(params)
      if @conversation.save
        @radioshow.conversations << @conversation
        redirect_to conversation_path(@conversation)
      else
        render 'radioshow/show'
      end
    end
  end

  # PUT /conversations/1
  # NOT IMPLEMENTED YET, I.E. NOT ROUTEABLE
  def update
    @conversation = Conversation.find(params[:id])

    if @conversation.update_attributes(params[:conversation])
      redirect_to(@conversation, :notice => 'Conversation was successfully updated.')
    else
      render :action => "edit", :status => :unprocessable_entity
    end
  end

  def toggle_rating
    @contribution = Contribution.find(params[:contribution_id])
    @rating_descriptor = RatingDescriptor.find_by_title(params[:rating_descriptor_title])

    @rating_group = RatingGroup.toggle_rating!(current_person, @contribution, @rating_descriptor)
    respond_to do |format|
      format.js
    end
  end

  def updates
    @conversation = Conversation.find(params[:id])
    @ratings = RatingGroup.ratings_for_conversation_by_contribution_with_count(@conversation, current_person)
    @new_contribution = @conversation.contributions.new
    @time = params[:time].to_datetime
    @items = @conversation.activities.where("item_created_at > ?", @time)

    @contributions = @conversation.contributions.where("created_at > ?", @time)
    @contributions = @contributions.where("owner <> ?", current_person.id) if current_person
    respond_to do |format|
      format.js
    end
  end

  private

  def force_friendly_id
    begin
      @conversation = Conversation.find params[:id]
    rescue ActiveRecord::RecordNotFound
      render 'public/404', :layout => nil, :status => 404 and return
    end

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the post_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if request.format != 'embed' and request.path != conversation_path(@conversation)
      return redirect_to request.parameters.merge({:id => @conversation.slug, :status => :moved_permanently})
    end
  end

  def prep_convo(params)
    @conversation = Conversation.new(params[:conversation])
    get_content_item(params)
    @conversation.content_items = [@content_item] if @content_item.present?

    @conversation.person = current_person
    @conversation.from_community = true
    @conversation.started_at = Time.now
    @conversation.contributions.each do |contribution|
      contribution.confirmed = true
      contribution.item = @conversation
    end
  end

  def get_content_item(params)
    if params[:radioshow_id] || params[:blog_id]
      @content_item = ContentItem.find(params[:radioshow_id]||params[:blog_id])
      @start_from = @content_item.content_type
    end
  end

end
