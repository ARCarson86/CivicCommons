class Admin::ContentItemsController < Admin::DashboardController
  
  load_and_authorize_resource :content_item
  
  #GET admin/content_items
  def index
    if params[:type]
      @filter = params[:type].classify
      @content_items = ContentItem.where(content_type: @filter).order('content_type ASC, published DESC, created_at DESC')
      @content_item_description = ContentItemDescription.find_or_initialize_by_content_type(@filter)
    else
      @filter = 'All'
      @content_items = ContentItem.all(order: 'content_type ASC, published DESC, created_at DESC')
    end
  end

  def new
    @content_item = ContentItem.new(params[:content_item])
    @authors = Person.where('admin = ? OR blog_admin = ?', true, true).order('first_name, last_name ASC')
    @content_item.author = current_person
    @content_item.published = Date.today
    @topics = Topic.all
  end

  def create
    @content_item = ContentItem.new(params[:content_item])

    begin
      error = false
      @content_item.published = params[:content_item][:published] ? Date.strptime(params[:content_item][:published], "%m/%d/%Y") : Date.today 
    rescue
      error = true
      @content_item.errors.add :published, "invalid date"
    end

    @content_item.embed_code = get_embed_code_from_embedly(@content_item.external_link, @content_item.embed_code) unless error

    @authors = Person.where('admin = ? OR blog_admin = ?', true, true).order('first_name, last_name ASC')

    if !error && @content_item.save
      flash[:notice] = "Your #{@content_item.content_type} has been created!"
      redirect_to admin_content_item_path(@content_item)
    else
      @topics = Topic.all
      render :new
    end
  end

  def create_description
    @filter = params[:type].classify
    @content_item_description = ContentItemDescription.new

    if @content_item_description.update_attributes(params['content_item_description'])
      redirect_to admin_content_items_type_path(@filter.underscore)
    else
      @content_items = ContentItem.where(content_type: @filter).order('content_type ASC, published DESC, created_at DESC')
      render :index
    end
  end

  def show
    @content_item = ContentItem.find(params[:id])
    @person = Person.find(@content_item.person_id)
  end

  def edit
    @content_item = ContentItem.find(params[:id])
    @authors = Person.where('admin = ? OR blog_admin = ?', true, true).order('first_name, last_name ASC')
    @content_item.url_slug = @content_item.slug
    @topics = Topic.all
  end

  def destroy
    @content_item = ContentItem.find(params[:id])
    @content_item.destroy
    flash[:notice] = "Successfully deleted content item"
    redirect_to admin_content_items_path
  end

  def update
    @content_item = ContentItem.find(params[:id])
    @authors = Person.where('admin = ? OR blog_admin = ?', true, true).order('first_name, last_name ASC')

    begin
      params[:content_item][:published] = params[:content_item][:published] ? Date.strptime(params[:content_item][:published], "%m/%d/%Y") : Date.today 
      error = false
    rescue
      error = true
      @content_item.errors.add :published, "invalid date"
    end

    params[:content_item][:embed_code] = get_embed_code_from_embedly(params[:content_item][:external_link], params[:content_item][:embed_code]) unless error

    if !error && @content_item.update_attributes(params[:content_item])
      flash[:notice] = "Successfully edited your #{@content_item.content_type}"
      redirect_to admin_content_item_path(@content_item)
    else
      @topics = Topic.all
      render :edit
    end
  end

  def update_description
    @filter = params[:type].classify
    @content_item_description = ContentItemDescription.find_by_content_type(@filter)

    if @content_item_description.update_attributes(params['content_item_description'])
      redirect_to admin_content_items_type_path(@filter.underscore)
    else
      @content_items = ContentItem.where(content_type: @filter).order('content_type ASC, published DESC, created_at DESC')
      render :index
    end
  end

  private

  def get_embed_code_from_embedly(external_link, embed_code = nil)
    if embed_code.blank? and external_link =~ URI::regexp(%w(http https))
      embed_code = EmbedlyService.get_simple_embed(external_link)
    end
    return embed_code
  end
  
  def verify_admin_and_content_item_admin
    if require_user and not current_person.admin? and not current_person.blog_admin?
      flash[:error] = "You must be an admin to view this page."
      redirect_to secure_session_url(current_person)
    end
  end

end
