class Admin::ContentItemsPeopleController < Admin::DashboardController

  authorize_resource :class => :admin_people

  before_filter :get_content_item
  #GET admin/content_items/123/people
  def index
    @hosts = @content_item.hosts
    @guests = @content_item.guests
  end

  def new
    if params[:letter] == 'all'
      @letter = params[:letter]
      @queried_letter = nil
    else
      @letter = params[:letter] || 'A'
      @queried_letter = @letter
    end
    @people = Person.find_confirmed_order_by_last_name(@queried_letter)
    @role = params[:role]
  end

  def create
    @person = Person.find(params[:person_id])
    @content_item.add_person(params[:role], @person)
    redirect_to admin_content_item_content_items_people_path(@content_item)
  end

  def destroy
    @person = Person.find(params[:id])
    @content_item.delete_person(params[:role], @person)
    redirect_to admin_content_item_content_items_people_path(@content_item)
  end

private
  def get_content_item
    @content_item = ContentItem.find(params[:content_item_id])
  end
end
