require 'spec_helper'


describe Admin::ContentItemLinksController do
  
  
  before(:each) do  
    @controller.stub(:verify_admin).and_return(true)
    # Admin::ContentItemLinksController.should_receive(:authorize_resource).and_return(true)
  end

  def stub_content_item(attributes={})
    @content_item ||= stub_model(ContentItem,attributes).as_null_object
  end
  
  def stub_person(attributes={})
    @person ||= stub_model(Person, attributes).as_null_object
  end
  
  def stub_link(attributes={})
    @link ||= stub_model(ContentItemLink, attributes).as_null_object
  end

  before(:each) do
    ContentItem.stub!(:find).and_return(stub_content_item)
    @controller.stub(:current_person).and_return(stub_person(:admin => true))
  end

  describe "GET index" do
    it "should get all links on a content_item" do
      @content_item.should_receive(:links).and_return([stub_link])
      get :index, :content_item_id => 1
    end
  end
  
  describe "GET new" do
    it "should build a new link" do
      link_double = double
      @content_item.should_receive(:links).and_return(link_double)
      link_double.should_receive(:build).and_return(stub_link)
      get :new, :content_item_id => 1
    end
  end

  describe "GET edit" do
    it "should find the link" do
      link_double = double
      @content_item.should_receive(:links).and_return(link_double)
      link_double.should_receive(:find).with("123")
      get :edit, :content_item_id => 1, :id => 123
    end
  end

  describe "POST create" do
    before(:each) do
      link_double = double
      @content_item.should_receive(:links).and_return(link_double)
      link_double.should_receive(:build).and_return(stub_link)
    end
    it "should redirect to links path if successfully saved" do
      @link.stub!(:save).and_return(true)
      post :create, :content_item_id => 1
      response.should redirect_to admin_content_item_content_item_links_path(@content_item)
    end
    it " should render :new action when not successfully saved" do
      @link.stub!(:save).and_return(false)
      post :create, :content_item_id => 1
      response.should render_template :action => :new
    end
  end

  describe "PUT update" do
    before(:each) do
      link_double = double
      @content_item.should_receive(:links).and_return(link_double)
      link_double.should_receive(:find).and_return(stub_link)
    end
    it "should redirect to links path if successfully saved" do
      @link.stub!(:update_attributes).and_return(true)
      put :update, :content_item_id => 1, :id => 123
      response.should redirect_to admin_content_item_content_item_links_path(@content_item)
    end
    it " should render :new action when not successfully saved" do
      @link.stub!(:update_attributes).and_return(false)
      put :update, :content_item_id => 1, :id => 123
      response.should render_template :action => :new
    end
  end
  

end

